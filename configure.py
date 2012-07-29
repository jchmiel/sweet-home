#!/usr/bin/env python
import logging, os
import shutil, time

FILELIST_FILE='filelist'

class Configurer:
  def __init__(self, fileListPath):
    self.fileListPath = fileListPath

  def run(self):
    self.findHomeDirectory()
    self.makeBackupDir()
    fileList = self.parseFileList(self.fileListPath)
    self.linkFiles(fileList, homeDirectory)

  def makeBackupDir(self):
    # Make a backup directory.
    bak = os.path.join(self.homeDirectory, '.sweet-home')
    if not os.path.exists(bak):
      os.mkdir(bak)
    tm = time.localtime()
    bak = os.path.join(self.homeDirectory, '.sweet-home', "backup-%04d%02d%02d%02d%02d" % (tm.tm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour, tm.tm_min))
    if not os.path.exists(bak):
      os.mkdir(bak)
    self.bakDir = bak

  def parseFileList(self, fileName):
    f = open(fileName)
    fileList = []
    for l in f:
      if not l.strip():
        continue # skip empty lines
      t = l.strip()
      if t.find('\t') >= 0:
        arr = t.split('\t')
        if not (arr[0].strip() and arr[1].strip()):
          logging.warn("Empty entries '%s' and '%s'" % (arr[0], arr[1]))
          continue
        fileList.append( (arr[0], arr[1]) )
      else:
        if not t.strip():
          logging.warn("Empty entry '%s'" % t)
          continue
        fileList.append( (t, t) )
    f.close()
    return fileList

  def linkFiles(self, copyList, destDir):
    for e in copyList:
      curDir = os.getenv('PWD')
      if not curDir:
        raise Exception('Cannot find current directory')
      src = os.path.join(curDir, e[0])
      dest = os.path.join(destDir, e[1])
      if not self.prepareDestPath(dest):
        continue
      self.makeLink(src, dest)

  def prepareDestPath(self, dest):
    if os.path.exists(dest):
      msg = '%s already exists overwrite (yes/no) ? [y/n]' % dest
      ans = self.getUserOption(msg, ('y', 'n'))
      if ans == 'n':
        return False
      self.backupPath(dest)
      self.rmPath(dest)
    return True

  def backupPath(self, path):
    assert self.homeDirectory
    assert self.bakDir
    homeRel = os.path.relpath(path, self.homeDirectory)
    dest = os.path.join(self.bakDir, homeRel)

    src = path
    print 'Backuping %s to %s' % (src, dest)
    if os.path.isdir(src):
      shutil.copytree(src, dest, True)
    elif os.path.isfile(src):
      # make sure path exists
      if not os.path.exists(os.path.dirname(dest)):
        os.makedirs(os.path.dirname(dest))
      shutil.copy(src, dest)
    return True

  def getUserOption(self, msg, options):
    while 1:
      ans = raw_input(msg)
      if ans and ans[0] in options:
        break
      print 'Please respond !', options
    return ans[0]

  def rmPath(self, path):
    if os.path.isdir(path):
      shutil.rmtree(path)
    elif os.path.isfile(path):
      os.remove(path)

  def makeLink(self, src, dest):
    #logging.info('linking %s to %s' % (src, dest))
    if os.path.isdir(src) or os.path.isfile(src):
      d, f = os.path.split(dest)
      if not os.path.isdir(d):
        cmd = 'mkdir -p %s' % d
        print cmd
        os.system(cmd)
      cmd = 'ln -s %s %s' % (src, dest)
      print cmd
      os.system(cmd)
    else:
      logging.warn('entry %s is neither file nor directory' % e[0])

  def findHomeDirectory(self):
    homeDirectory = os.getenv('HOME')
    logging.info('HOME is %s' % homeDirectory)

def main():
  FORMAT = "%(levelname)s: %(message)s"
  logging.basicConfig(format=FORMAT, level=logging.DEBUG)

  Configurer conf = Configurer(FILELIST_FILE)
  conf.run()

if __name__ == '__main__':
  main()
