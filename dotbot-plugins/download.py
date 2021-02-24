from os import chmod, stat
import dotbot

from os.path import expanduser, isfile
from urllib.request import urlretrieve

CHUNK_SIZE = 4096  # 4 KiB


class DotbotDownload(dotbot.Plugin):
    """Download a file to specified destination."""

    _directive = "download"

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError("Download cannot handle directive %s" % directive)
        return self._process_commands(data)

    def _process_commands(self, data):
        success = True
        defaults = self._context.defaults().get("download", {})

        for path, config in data.items():
            if "url" not in config:
                self._log.error("Failed to download file! (no url specified)")
                success = False
                continue
            url = config["url"]
            full_path = expanduser(path)
            description = config.get("description", url)
            force = config.get("force", defaults.get("force", True))
            quiet = config.get("quiet", defaults.get("quiet", False))
            executable = config.get("executable", defaults.get("executable", False))

            self._log.lowinfo("Downloading %s" % description)

            if isfile(full_path):
                if force and not quiet:
                    print("Overwriting:", path)
                else:
                    continue

            urlretrieve(url, full_path)

            # make executable
            if executable:
                mode = stat(full_path).st_mode
                mode |= (mode & 0o444) >> 2
                chmod(full_path, mode)

        if success:
            self._log.info("All files have been downloaded")
        else:
            self._log.error("Some files were not successfully downloaded")
        return success
