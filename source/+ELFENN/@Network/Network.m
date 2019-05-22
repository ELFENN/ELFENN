classdef Network < handle
    %NETWORK - ELFENN.Cell class
    %
    % Inputs:
    %    None
    %
    % Outputs:
    %    None
    %
    % Example (creating network):
    %    exampleNetwork = ELFENN.Network();
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    properties
        cells; % List of cells
        dynamicsParameters; % Struct of parameters for ODE
    end
    
    properties(Hidden)
        isDiscretized = 0; % Is the Network discretized
        externalSynapseArray; % List of external synapses
        chemicalSynapseArray; % List of chemical synapses
        resistivefdm; % The combined resistive finite difference matrix
        gapjunctionfdm = sparse([]); % Finite diffence matrix for Gap Junctions
        eCellElectrodeArray; % Extracellular electrode list
        plateArray; % Extracellular plate array
        iCellElectrodeArray; % Intracellular electrode list
    end
    
    properties(Dependent)
        nTotalSeg; % Number of segments in network (dimension of FDmatrix)
        eCellPosition; % Extracellular electrode positions
        platePlanes; % Extracellular plate planes
        platePoints; % Point on the extracellular plate
        plateSeparation; % Distance between extracellular plates
    end
    
    methods
        function eCellPosition = get.eCellPosition(this)
            eCellPosition = zeros(length(this.eCellElectrodeArray), 3);
            for ix = 1:length(this.eCellElectrodeArray)
                eCellPosition(ix, :) = this.eCellElectrodeArray(ix).position;
            end
        end
        
        function eCellTotalCurrent = ecelltotalcurrent(this, t, y)
            eCellTotalCurrent = zeros(length(this.eCellElectrodeArray), 1);
            for ix = 1:length(this.eCellElectrodeArray)
                eCellTotalCurrent(ix) = this.eCellElectrodeArray(ix).stim_function(t, y);
            end
        end
        
        function iCellTotalCurrent = icelltotalcurrent(this, t, y, nTotalSeg)
            iCellTotalCurrent = zeros(nTotalSeg, 1);
            for ix = 1:length(this.iCellElectrodeArray)
                injected_segment = this.iCellElectrodeArray(ix).position;
                iCellTotalCurrent(injected_segment) = this.iCellElectrodeArray(ix).stim_function(t, y);
            end
        end
        
        function [nTotalSeg] = get.nTotalSeg(this)
            nTotalSeg = sum([this.cells.nTotalSeg]);
        end
        
        function platePlanes = get.platePlanes(this)
            platePlanes = zeros(length(this.plateArray), 3);
            for ix = 1:length(this.plateArray)
                platePlanes(ix, :) = this.plateArray(ix).plane;
            end
        end
        
        function platePoints = get.platePoints(this)
            platePoints = zeros(length(this.plateArray), 3);
            for ix = 1:length(this.plateArray)
                platePoints(ix, :) = this.plateArray(ix).point;
            end
        end
        
        function plateSeparation = get.plateSeparation(this)
            plateSeparation = zeros(length(this.plateArray), 1);
            for ix = 1:length(this.plateArray)
                plateSeparation(ix, :) = this.plateArray(ix).separation;
            end
        end
        
        function plateTotalCurrent = platetotalcurrent(this, t, y)
            plateTotalCurrent = zeros(length(this.plateArray), 1);
            for ix = 1:length(this.plateArray)
                plateTotalCurrent(ix) = this.plateArray(ix).stim_function(t, y);
            end
        end
        
        function synapseTotalCurrent = synapsetotalcurrent(this, t, v, nTotalSeg)
            synapseTotalCurrent = zeros(nTotalSeg, 1);
            for ix = 1:length(this.externalSynapseArray)
                injected_segment = this.externalSynapseArray(ix).position;
                synapseTotalCurrent(injected_segment) = synapseTotalCurrent(injected_segment) + ...
                    this.externalSynapseArray(ix).current_function(t(1), v(injected_segment));
                
                
                
            end
            
            for ix = 1:length(this.chemicalSynapseArray)
                injected_segment = this.chemicalSynapseArray(ix).position;
                synapseTotalCurrent(injected_segment) = synapseTotalCurrent(injected_segment) + ...
                    this.chemicalSynapseArray(ix).current_function(t(1), v(injected_segment));
                
                
                
            end
        end
        
        addcell(this, cell, varargin)
        addchemicalsynapse(this, position, presyn, f, parameters, varargin)
        addelectricalsynapse(this, index1, index2, conductance)
        addexternalsynapse(this, position, f, parameters, varargin)
        addextracellularelectrode(this, position, f, parameters)
        addextracellularplate(this, point, plane, sep, f, parameters)
        addintracellularelectrode(this, position, f, parameters, varargin)
        complete(this)
        setdynamics(this, p);
        
        solutionID = getallnamedsolutionindex(this, name)
        cell = getcellbyname(this, name)
        solutionID = getnamedsolutionindex(this, variableName, cellNames, sectionNames)
        [cellname1, cellname2, segmentid1, segmentid2] = jumpclosestto(this, target);
        segment = sectionsearchbyseg(this, id);
        segment = getsegmentbyid(this, id);
        [cellname, segmentid, out] = segmentclosestto(this, target, varargin);
    end
    
    methods(Hidden)
        assignsolutionindex(this, varargin)
        calculatefdm(this)
        
        [r, l, p, v, s] = getlfpparameters(this)
        [recorders, map] = getrecordersandmap(this)
    end
end
