function discretize(this)
    %DISCRETIZE - Discretize section
    %Break up a section into nseg evenly spaced pieces called segments to
    %discretize the cable equation into an explicit finite difference form
    %
    % Inputs:
    %    None
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a section named exampleSection, if you do
    %    not please see ELFENN.Section.
    %
    %    exampleSection.discretize()
    %
    % see also ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    this.segments = [];
    this.connectivity = [];
    if strcmp(this.sectionGeometry, 'C')
        vector = this.endPoint - this.startPoint;
        R = getrotationmatrixofvector(vector);
        
        nodeLength = this.sectionLength / this.nSeg;
        
        startNode = 0.5 * nodeLength;
        endNode = this.sectionLength - 0.5 * nodeLength;
        ys = startNode:nodeLength:endNode;
        nodes = zeros(this.nSeg, 3);
        nodes(:, 2) = ys;
        
        recorderArray = zeros(2*this.nAxes, 3, this.nSeg);
        for ix = 1:this.nSeg
            rawRecorders = ELFENN.Segment.calculaterecorders(this.radius, ...
                this.nAxes, this.sectionGeometry, nodes(ix, 2));
            
            
            
            recorderArray(:, :, ix) = (R * (rawRecorders'))' + this.startPoint;
        end
        nodes = (R * (nodes'))' + this.startPoint;
        previousSegment = ELFENN.Segment(string('node1'), nodes(1, :), recorderArray(:, :, 1));
        this.connectsegment(previousSegment)
        for ix = 2:this.nSeg
            newSegment = ELFENN.Segment(string(['node', num2str(ix)]), nodes(ix, :), recorderArray(:, :, ix));
            this.connectsegment(previousSegment, newSegment);
            previousSegment = newSegment;
        end
    else
        recorderArray = ELFENN.Segment.calculaterecorders(this.radius, this.nAxes, this.sectionGeometry);
        center = (this.startPoint + this.endPoint) / 2; % TODO: CHECK THIS!
        recorderArray = recorderArray + center;
        newSegment = ELFENN.Segment(string('node1'), [this.startPoint + this.endPoint]/2, recorderArray);
        this.connectsegment(newSegment);
    end
    
    %------------- END OF CODE --------------
end