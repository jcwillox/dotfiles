import subprocess

import dotbot


class DotbotApt(dotbot.Plugin):
    _directive = "apt"

    def can_handle(self, directive):
        return self._directive == directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError("apt cannot handle directive %s" % directive)
        success = True
        defaults = self._context.defaults().get(self._directive, {})
        self.quiet = defaults.get("quiet", False)

        if isinstance(data, str):
            data = [data]

        for package in data:
            self._log.lowinfo("Installing package '%s' " % package)
            if not self._update_package(package):
                success = False

        return success

    def _update_package(self, package):
        try:
            subprocess.run(
                "apt install -y %s" % package,
                shell=True,
                check=True,
                stdout=not self.quiet,
            )
            return True
        except subprocess.CalledProcessError:
            self._log.error("apt failed to install package '%s'..." % package)
            return False
