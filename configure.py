#!/usr/bin/env python
import configparser
import glob
import hashlib
import logging
import optparse
import os
import time


DEF_CONFIG_FILE='configure.conf'


class Colors:
  HEADER = '\033[95m'
  OKBLUE = '\033[94m'
  OKGREEN = '\033[92m'
  WARNING = '\033[93m'
  FAIL = '\033[91m'
  ENDC = '\033[0m'


class Error(Exception):
  pass


class PathToLink:
  def __init__(self, path, dest_path):
    self.path = path
    self.dest_path = dest_path


class Configurer:

  def __init__(self, config_file, target_dir=None):
    self.config_file = config_file
    self.target_dir = target_dir

  def run(self):
    self._fill_target_dir_if_needed()
    path_list = self._parse_configfile()
    self._check_paths(path_list)
    backup_dir = self._make_backup_dir()
    self._link_paths(path_list, backup_dir)

  def _check_paths(self, path_list):
    if not os.path.exists(self.target_dir):
      raise Error('Target dir %s doesn\'t exist' % self.target_dir)
    for entry in path_list:
      if not os.path.exists(entry.path):
        raise Error('Path %s doesn\'t exist' % entry.path)

  def _link_paths(self, path_list, backup_dir):
    print('%sLinking paths...%s' % (Colors.OKBLUE,  Colors.ENDC))
    backups = []
    for entry in path_list:
      dest_path = os.path.join(self.target_dir, entry.dest_path)
      if os.path.islink(dest_path):
        print('Path %s is a link, skipping.' % dest_path)
        continue
      if self._backup_path_if_needed(entry.dest_path, backup_dir):
        backups.append(entry.dest_path)
      self._make_parent_dir(dest_path)
      self._symlink(entry.path, dest_path)
      print(entry.path)
    if backups:
      print('Paths backed up to %s are %s.' % (backup_dir, ','.join(backups)))
    print('%sAll done.%s' % (Colors.OKGREEN,  Colors.ENDC))

  def _symlink(self, src, dest):
    os.symlink(os.path.abspath(src),
               os.path.abspath(dest))

  def _make_parent_dir(self, path):
    dirname = os.path.dirname(path)
    self._mkdir(dirname)

  def _mkdir(self, path):
    if os.path.isdir(path):
      return
    if os.path.isfile(path):
      raise Error('Cannot create path %s, already exists' % path)
    head, tail = os.path.split(path)
    self._mkdir(head)
    os.mkdir(path)

  def _backup_path_if_needed(self, path, backup_dir):
    src = os.path.join(self.target_dir, path)
    if not os.path.exists(src):
      return False
    dest = os.path.join(backup_dir, path)
    os.rename(src, dest)
    return True

  def _parse_configfile(self):
    config = configparser.RawConfigParser()
    config.read(self.config_file)
    path_list = []
    dotfiles = config.get('main', 'dotfiles')
    patterns = dotfiles.split(' ')
    for p in patterns:
      for f in glob.glob(p):
        path_list.append(PathToLink(f,'.'+f))

    files = config.get('main', 'files')
    patterns = files.split(' ')
    for p in patterns:
      for f in glob.glob(p):
        path_list.append(PathToLink(f,f))
    return path_list

  def _make_backup_dir(self):
    dirname=hashlib.md5(str(time.time()).encode('utf-8')).hexdigest()
    backup_dir = os.path.join(self.target_dir, '.sweet-home')
    if not os.path.exists(backup_dir):
      os.mkdir(backup_dir)
    backup_dir = os.path.join(backup_dir, dirname)
    if not os.path.exists(backup_dir):
      os.mkdir(backup_dir)
    return backup_dir

  def _fill_target_dir_if_needed(self):
    if not self.target_dir:
      self.target_dir = os.getenv('HOME')


def main():
  parser = optparse.OptionParser()
  parser.add_option(
      "-t", "--target_dir", dest="target_dir", default=None, metavar='TARGET',
      help="Install all files to TARGET dir (default is user's home).")
  parser.add_option(
      "-c", "--config_file", dest="config_file", default=DEF_CONFIG_FILE,
      help="Use specified config file")
  opts, args = parser.parse_args()

  FORMAT = "%(levelname)s: %(message)s"
  logging.basicConfig(format=FORMAT, level=logging.DEBUG)
  confgurer = Configurer(
      config_file=opts.config_file, target_dir=opts.target_dir)
  confgurer.run()


if __name__ == '__main__':
  main()
