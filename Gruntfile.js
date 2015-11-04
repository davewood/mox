module.exports = function(grunt) {

    grunt.initConfig({
        bowerRequirejs: {
            target: {
                rjsConfig: 'static/js/app.js',
                options: { exclude: ['requirejs'] }
            }
        }
    });

    grunt.loadNpmTasks('grunt-bower-requirejs');

    grunt.registerTask('default', ['bowerRequirejs']);

};
