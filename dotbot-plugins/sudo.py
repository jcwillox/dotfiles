import json
import os
import subprocess
import sys
from tempfile import NamedTemporaryFile

import dotbot


class Sudo(dotbot.Plugin):
    _directive = "sudo"

    def can_handle(self, directive):
        return self._directive == directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError("sudo cannot handle directive %s" % directive)

        # ignore sudo directive on windows
        if os.name == "nt":
            return True

        defaults = self._context.defaults()
        self.allow_user = defaults.get(self._directive, {}).get("allow_user", False)

        # check if user can sudo
        result = subprocess.run(
            "sudo -v", stdin=True, stderr=True, stdout=True, shell=True
        )
        if result.returncode != 0:
            if not self.allow_user:
                self._log.lowinfo("User does not have root access")
                return False
            self._log.lowinfo("Running as user")
            args = sys.argv
        else:
            self._log.lowinfo("Running as root")
            args = ["sudo"] + sys.argv

        data = [{"defaults": defaults}] + data

        with NamedTemporaryFile(mode="w", suffix=".json") as file:
            file.write(json.dumps(data))
            file.flush()

            for idx, value in enumerate(args):
                if value in ["-c", "--config-file"]:
                    args[idx + 1] = file.name

            self._log.debug("sudo: args -> {}".format(args))

            try:
                subprocess.run(args, stdin=True, stderr=True, stdout=True, check=True)
                return True
            except:
                return False

        # if root run normally
        # if can sudo re-run with sudo
        # if can't sudo then check if we can run as user

        # app = self._find_dotbot()
        # base_directory = self._context.base_directory()
        # data = [{'defaults': self._context.defaults()}] + data
        # plugins = self._collect_plugins()
        # sudo_conf = path.join(path.dirname(__file__), 'sudo.conf.json')

        # self._write_conf_file(sudo_conf, data)

        # proc_args = [
        #     'sudo', app,
        #     '--base-directory', base_directory,
        #     '--config-file', sudo_conf
        #     ] + plugins
        # self._log.debug('sudo: args to pass: {}'.format(proc_args))

        # try:
        #     self._log.lowinfo('sudo: begin subprocess')
        #     subprocess.check_call(
        #         proc_args,
        #         stdin=subprocess.PIPE)
        #     self._log.lowinfo('sudo: end subprocess')
        #     self._delete_conf_file(sudo_conf)
        #     return True
        # except subprocess.CalledProcessError as e:
        #     self._log.lowinfo('sudo: end subprocess')
        #     self._log.error(e)
        #     return False

    # def _collect_plugins(self):
    #     ret = []
    #     for plugin in module.loaded_modules:
    #         # HACK should we compare to something other than _directive?
    #         if plugin.__name__ != self._directive:
    #             ret.extend(iter(['--plugin', plugin.__file__]))
    #     return ret

    # def _delete_conf_file(self, conf_file):
    #     if path.exists(conf_file):
    #         remove(conf_file)

    # def _find_dotbot(self):
    #     base = path.dirname(path.dirname(dotbot.__file__))
    #     ret = path.join(base, 'bin', 'dotbot')
    #     self._log.debug('sudo: dotbot app path: {}'.format(ret))
    #     return ret

    # def _write_conf_file(self, conf_file, data):
    #     self._delete_conf_file(conf_file)
    #     with open(conf_file, 'w', encoding='utf-8') as jfile:
    #         json.dump(data, jfile, ensure_ascii=False)
