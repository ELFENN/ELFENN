import json
import pysftp
import sys
import time

class ServerInterface(object):
    def __init__(self, configpath='Tests/config.json'):
        self.serverConfig = None
        with open(configpath) as c:
            self.serverConfig = json.load(c)
        if self.serverConfig is not None:
            self.serverConfig = self.serverConfig['server']
            self.modelfolder = self.serverConfig['model_folder']
            self.model_config = None
            self.cnopts = pysftp.CnOpts()
            self.cnopts.hostkeys = None

    def copymodel(self, model_path, model_name):

        with pysftp.Connection(self.serverConfig['name'],
                               username=self.serverConfig['user'],
                               password=self.serverConfig['password'],
                               cnopts=self.cnopts) as sftp:

            server_model_path = self.serverConfig['model_folder'] + '/' + model_name
            try:
                sftp.listdir(server_model_path)
                #print(server_model_path + " already exists")
            except FileNotFoundError:
                #print('Creating Folder:\t' + server_model_path)
                sftp.mkdir(server_model_path)
                sftp.mkdir(server_model_path + '/modelResult')

            sftp.chdir(server_model_path)
            #print('Copying Model:\t' + model_path)
            sftp.put(model_path)

    def readconfig(self, config_path):
        self.model_config = None
        with open(config_path) as c:
            self.model_config = json.load(c)

    @staticmethod
    def format_parames(params):
        parameters = list(params)
        parameters.sort()
        parameter_list = []
        for p in parameters:
            parameter_list.append(params[p])
        return ' '.join(['"' + str(param) + '"' for param in parameter_list])

    def runmodel(self, model_path, model_name, config_path, model_version, download_path):
        self.copymodel(model_path, model_name)
        self.readconfig(config_path)

        with pysftp.Connection(self.serverConfig['name'],
                               username=self.serverConfig['user'],
                               password=self.serverConfig['password'],
                               cnopts=self.cnopts) as sftp:

            server_pwd = self.serverConfig['model_folder'] + '/' + model_name
            model_class = 'model.py'
            if "LFP" in model_path:
                model_class = 'LFP_model.py'
            cmd_header = '~/anaconda2/bin/python ' + server_pwd + "/" +model_class
            formated_parameters = self.format_parames(self.model_config[model_version])
            cmd = cmd_header + " " + formated_parameters + " " + server_pwd
            print(cmd)
            print(sftp.execute(cmd))
            print('Downloading Result')
            time.sleep(1)
            if "LFP" in model_path:
                sftp.get(server_pwd + '/modelResult/' + self.model_config[model_version]['name'] + "_LFP.mat", download_path)            
            else:
                sftp.get(server_pwd + '/modelResult/' + self.model_config[model_version]['name'] + ".csv", download_path)