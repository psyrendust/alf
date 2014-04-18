/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Task configuration.
    pkg: grunt.file.readJSON('package.json'),
    changelog: {
      alf: {
        options: {
        featureRegex: /^(.*)(closes|updates|adds|adding)(.*)$/gim,
          fixRegex: /^(.*)(fixes|removes)(.*)$/gim,
          dest: 'release-notes/<%= pkg.version %>.md',
          template: '## <%= pkg.version %> (<%= grunt.template.today("mmmm dS, yyyy") %>)\n\n{{> features}}{{> fixes}}',
          partials: {
            features: '{{#if features}}#### New Features\n{{#each features}}{{> feature}}{{/each}}\n{{else}}{{> empty}}{{/if}}',
            feature: '  * {{this}}\n',
            fixes: '{{#if fixes}}#### Bug Fixes\n{{#each fixes}}{{> fix}}{{/each}}\n{{else}}{{> empty}}{{/if}}',
            fix: '  * {{this}}\n'
          }
        }
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-changelog');

  // Default task.
  grunt.registerTask('default', ['changelog:alf']);

};
