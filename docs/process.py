#!/usr/bin/python3

import os
from os import close, remove
from tempfile import mkstemp
from shutil import move

TMP_FILE_STR = '%TEMP-FILE FOR BUILDING DOCUMENTATION'
DOCUMENTED_CLASSES = ['Motor', 'Sensor', 'EV3', 'usbBrickIO', 'btBrickIO']  # If a new class shall be documented, it needs to be added to this list

def preprocess():
    """Preprocesses data for building documentation

    Fixes the following problems:
        - Comment out enumerations (The MATLAB Sphinx
        extension takes veeery (or even infinitely?) long to build the
        documentation if a class contains an enumeration)
        - Insert comments for creating a list of methods a class contains (Names of
        relevant methods taken from corresponding .rst-file. This is necessary
        as the MATLAB Sphinx Extension has no functionality for creating compact
        method lists.:( )

        -> After creating the documentation, the changes are unmade (postprocess())

    Prerequisites:
        - Has to be inside toolboxFile/docs
        - comments in the MATLAB source files shouldn't include the keywords
        'classdef' and 'enumeration'
    """

    code_dir = os.path.abspath('../source')
    files = _matlab_files(os.listdir(code_dir))  # Get list of all toolbox source files

    documented_methods = _find_documented_methods()  # Get names of all documented methods from .rst-files

    n_files = len(files)
    for n, file_name in enumerate(files):
        try:
            fh, abs_path = mkstemp()
            with open(code_dir + "/" + file_name, 'r') as f:
                with open(abs_path, 'w') as ftemp:
                    content = f.readlines()
                    if content[0] == TMP_FILE_STR + '\n':
                        raise RuntimeError('Found already preprocessed file: ' + file_name)

                    try:
                        for i, line in enumerate(content):  # Worst runtime ever: Iterate over entire file line by line
                            if _ignore_line(line) is False:
                                if 'classdef' in line:  # Insert method-list string in relevant class docs
                                    class_name = line.replace(' ', '').split('%')[0].split('<')[0].split('classdef')[1]
                                    try:
                                        methods = documented_methods[class_name]

                                        line = line.replace('\n', '') + '  ' + TMP_FILE_STR + '\n'

                                        _write_lines(content[:i], ftemp)
                                        _write_lines([line], ftemp)
                                        _write_lines(_method_lines(methods), ftemp)
                                        _write_lines(content[i+1:], ftemp)

                                    except KeyError:
                                        ignore_class = True
                                        continue

                                    close(fh)
                                    remove(code_dir + "/" + file_name)
                                    move(abs_path, code_dir + "/" + file_name)

                                    raise StopIteration
                                elif 'enumeration' in line:  # Comment out enumeration
                                    ftemp.write(TMP_FILE_STR + '\n')
                                    _write_lines(content[:i], ftemp)
                                    for j, enum_line in enumerate(content[i:]):
                                        ftemp.write(" %"+enum_line)
                                        if " end" in enum_line or "end\n" == enum_line:
                                            _write_lines(content[i+1+j:], ftemp)
                                            close(fh)
                                            remove(code_dir + "/" + file_name)
                                            move(abs_path, code_dir + "/" + file_name)

                                            raise StopIteration
                    except StopIteration:  # This exception is like a 'continue' for the outer loop when inside an inner loop
                        pass
        except IOError:
            pass

        if file_name == 'EV3.m':
            fh, abs_path = mkstemp()
            with open(code_dir + "/" + file_name, 'r') as f:
                with open(abs_path, 'w') as ftemp:
                    content = f.readlines()
                    for i, line in enumerate(content):
                        if 'methods (Access = {?' in line:
                            line = line.replace('methods (Access = {?', 'methods %(Access = {?')

                            _write_lines(content[:i], ftemp)
                            _write_lines([line], ftemp)
                            _write_lines(content[i+1:], ftemp)

                            close(fh)
                            remove(code_dir + "/" + file_name)
                            move(abs_path, code_dir + "/" + file_name)

                            break

def postprocess():
    """Postprocesses data after building documentation

    This function reverses the changes done by preprocess() and calls
    postprocess_html_files afterwards.
    """
    code_dir = os.path.abspath('../source')
    files = _matlab_files(os.listdir(code_dir))

    documented_methods = _find_documented_methods()

    n_files = len(files)
    for n, file_name in enumerate(files):
        try:
            fh, abs_path = mkstemp()
            with open(code_dir + "/" + file_name, 'r') as f:
                with open(abs_path, 'w') as ftemp:
                    content = f.readlines()
                    try:
                        for i, line in enumerate(content):  # Worst runtime ever
                            if 'classdef' in line and '%TEMP-FILE FOR BUILDING DOCUMENTATION' in line:
                                class_name = line.replace(' ', '').split('%')[0].split('<')[0].split('classdef')[1]
                                try:
                                    n_methods = len(documented_methods[class_name])

                                    line = line.replace('  '+TMP_FILE_STR, '')

                                    _write_lines(content[:i], ftemp)
                                    _write_lines([line], ftemp)
                                    _write_lines(content[i+n_methods+5:], ftemp)

                                except KeyError:
                                    continue

                                close(fh)
                                remove(code_dir + "/" + file_name)
                                move(abs_path, code_dir + "/" + file_name)

                                raise StopIteration
                            elif 'enumeration' in line:
                                _write_lines(content[1:i], ftemp)
                                for j, enum_line in enumerate(content[i:]):
                                   ftemp.write(enum_line.replace(' %', '', 1))
                                   if " end" in enum_line or "end\n" == enum_line:
                                        _write_lines(content[i+1+j:], ftemp)
                                        close(fh)
                                        remove(code_dir + "/" + file_name)
                                        move(abs_path, code_dir + "/" + file_name)

                                        raise StopIteration  # At this point, entire file has been processed: continue outer loop
                    except StopIteration:
                        pass
        except IOError:
            pass

        if file_name == 'EV3.m':
            fh, abs_path = mkstemp()
            with open(code_dir + "/" + file_name, 'r') as f:
                with open(abs_path, 'w') as ftemp:
                    content = f.readlines()
                    for i, line in enumerate(content):
                        if 'methods %(Access = {?' in line:
                            line = line.replace('methods %(Access = {?', 'methods (Access = {?')

                            _write_lines(content[:i], ftemp)
                            _write_lines([line], ftemp)
                            _write_lines(content[i+1:], ftemp)

                            close(fh)
                            remove(code_dir + "/" + file_name)
                            move(abs_path, code_dir + "/" + file_name)

                            break

    postprocess_html_files()

def postprocess_html_files():
    """ Postprocesses the created doc html-files

    Some formatting and internal errors occurs when the HTML-files are created.
    The following bugs have been found and are being fixed by this function:
        - Replace ` with ' (This is necessary to make code examples
        copy-pastable. During the creation of the html-files ' has been replaced
        by ` for some reason.)
        - Delete module name from class documentation (Sphinx wrongly interprets
        the file-name of the toolbox as the module name, which it would be if it
        were dealing with Python)
        - Replace wrong hrefs by internal links (Some would-be-internal links
        wrongly point to some ominous 'source.html'-file)
    """

    for file_name in DOCUMENTED_CLASSES:
        current_file = os.path.abspath('_build/html/' + file_name + '.html')
        try:
            fh, abs_path = mkstemp()
            with open(current_file, 'r') as f_old:
                with open(abs_path, 'w') as f_new:
                    content = f_old.readlines()
                    for i, line in enumerate(content):
                        # Replace ` with '
                        if('&#8216' in line or '&#8217' in line):
                            line = line.replace('&#8216;', '\'').replace('&#8217;', '\'')

                        # Delete module name from class documentation
                        ugly_module_string = '<code class="descclassname">source.</code>'
                        if(ugly_module_string in line):
                            line = line.replace(ugly_module_string, '')

                        # Replace wrong hrefs by internal links
                        wrong_href = 'source.html'
                        if(wrong_href in line):
                            line = line.replace(wrong_href, '')

                        f_new.write(line)
                    close(fh)
                    remove(current_file)
                    move(abs_path, current_file)
        except IOError:
            print('WARNING: Couldn''t postprocess html-file ' + current_file)
            continue

## Helper functions
def _ignore_line(line) -> bool:
    return (line.startswith('%') or line == '\n' or line == '')

def _write_lines(lines, f):
    for line in lines:
        f.write(line)

def _matlab_files(files) -> list:
    return [f for f in files if (f.endswith(".m") and "_" not in f and "proto" not in f)]

def _rst_files(files) -> list:
    return [f for f in files if f.endswith(".rst")]

def _method_lines(methods) -> list:
    doc_lines = ['    %\n']
    doc_lines.append('    % *List of methods*:\n')
    for method in methods:
        doc_lines.append('    %             * :meth:`' + method + '`\n')
    doc_lines.append('    %\n')
    doc_lines.append('    %\n')

    return doc_lines

def _find_documented_methods():
    files = _rst_files(os.listdir(os.path.abspath('.')))

    doc_methods = {}
    for file_name in files:
        with open(file_name) as f:
            content = f.readlines()
            class_name = ''

            for i, line in enumerate(content):
                class_string = '.. autoclass:: '
                if class_name != '':
                    if ':members:' in line:  # Found line with method names
                        method_names = line.split(':members: ')[1].split(', ')
                        method_names = [m.replace('\n', '') for m in method_names[:]]
                        doc_methods[class_name] = method_names

                if class_string in line:
                    class_name = line.split(class_string)[1].replace('\n', '')

    return doc_methods
