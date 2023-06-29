#!/usr/bin/env python
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
#

"""
Open files in a grid in vim
"""
import sys
import argparse
import os

def_columns = 3

def cl_move(cmd, count):
    return [ "-c", str(count) + "wincmd " + cmd ];

def get_command_line(files, columns):
    count = len(files)
    cl = [ "vim" ]
    if (count < columns):
        # Trivial case
        cl.append("-O")
        return cl + files
    fullrows = count // columns

    # First row is odd, because first file is naked on CL
    cl.append(files.pop(0));
    for column in range(1, columns):
        cl.append("-c")
        cl.append("vsplit " + files.pop(0));
    # And traverse back to first column
    cl.extend(cl_move("h", columns - 1))

    # Now full rows
    for row in range(1, fullrows):
        for column in range(0, columns):
            cl.append("-c")
            cl.append("split " + files.pop(0));
            cl.extend(cl_move("l", 1))
        cl.extend(cl_move("h", columns - 1))

    if (len(files)):
        for column in range(0, len(files)):
            cl.append("-c")
            cl.append("split " + files.pop(0));
            cl.extend(cl_move("l", 1))

    return cl;

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--columns", help="Number of columns. Default: " +
                        str(def_columns), type=int, default=def_columns)
    parser.add_argument("files", help="Files to open", nargs="*");
    args = parser.parse_args()
    print("Splitting " + str(len(args.files)) + " files into " + str(args.columns) + " columns");
    cl = get_command_line(args.files, args.columns);
    print(cl);
    os.execvp("nvim", cl);


if __name__ == "__main__":
    main()
