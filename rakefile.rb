require 'rubygems'
require 'albacore'
require 'fileutils'
require 'net/http'
require 'uri'
require 'rexml/document'

PROJECT_ROOT = Dir.pwd
OUTPUT_ROOT = File.join(PROJECT_ROOT, 'Output')

MSBUILD = "C:/Windows/Microsoft.NET/Framework/v4.0.30319/MSBuild.exe" 
SOLUTION = "PetaPoco.sln"

@config = ENV["CONFIG"] || 'Debug'

task :default => :build

desc 'Clean output'
task :clean do
	FileUtils.remove_dir('output', true)
end	

desc "Run a sample assembly info generator"
assemblyinfo :assembly_info do |asm|
	asm.version = "0.1.2.3"
	asm.company_name = "a test company"
	asm.product_name = "a product name goes here"
	asm.title = "my assembly title"
	asm.description = "this is the assembly description"
	asm.copyright = "copyright some year, by some legal entity"
	asm.custom_attributes :SomeAttribute => "some value goes here", :AnotherAttribute => "with some data"
	asm.output_file = "spec/support/AssemblyInfo/AssemblyInfo.cs"
end
	
desc "Compile a library project"
msbuild :build do |msb, args|
	msb.command = MSBUILD
	msb.properties  = { "Configuration" => "#{@config}", "OutputPath" => "#{OUTPUT_ROOT}" }
	msb.targets :Build
	msb.verbosity = "normal"
	msb.log_level = :verbose
	msb.solution = SOLUTION
end