'use strict';
// jshint node: true

var path = require('path');

// Include Gulp & Tools We'll Use
var gulp = require('gulp');
var gutil = require('gulp-util');
var $ = require('gulp-load-plugins')();
var del = require('del');
var runSequence = require('run-sequence');
var browserSync = require('browser-sync');
var reload = browserSync.reload;
var superstatic = require('superstatic');
var shell = require('gulp-shell');

gulp.task('build', shell.task(['make']));

gulp.task('quickbuild', shell.task(['make quickbuild']));

gulp.task('serve', ['default'], function () {
  browserSync({
    notify: false,
    server: {
      baseDir: ['target', 'bower_components', 'node_modules']
    }
  });

  gulp.watch(['demo/*.html'], reload);
  gulp.watch(['*.html'], ['quickbuild', reload]);
});

gulp.task('default', function (cb) {
  runSequence(
    'build',
    cb);
});


try { require('web-component-tester').gulp.init(gulp); } catch (err) {}
try { require('require-dir')('tasks'); } catch (err) {}
