function solutionID = getnamedsolutionindex(this, variableName, cellNames, sectionNames)
    %GETNAMEDSOLUTIONINDEX - Get the indeces for a partiuclar set of segments
    %Given a list of cells and sections, get the indeces for thier variables.
    %Warning this is poorly documented and may not be used.
    %
    % Inputs:
    %    v - Name of variable (String)
    %    c - Name of cells (String array)
    %    s - Name of sections (String array)
    %
    % Outputs:
    %    solutionID - ID for requested cell and sections
    %
    % Raises:
    %    None
    %
    % Example:
    %   This function has been deprecated and is only maintained for its use in
    %   unit tests
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    solutionID = [];
    for ix = 1:length(cellNames)
        cellName = cellNames(ix);
        cell = this.getcellbyname(cellName);
        sectionNamesByCell = sectionNames(ix);
        for iy = 1:length(sectionNamesByCell)
            sectionName = cell2mat(sectionNamesByCell(iy));
            section = cell.getsectionbyname(sectionName);
            ID_holder = [section.segments.ODEID];
            solutionID = [solutionID, ID_holder.(variableName)];
        end
    end
    
    %------------- END OF CODE --------------
end