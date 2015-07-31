function d2 = mydist(XI, XJ)
    rowI = XI;
    num_rows = size(XJ,1);
    d2 = zeros(num_rows,1);
    for n=1:num_rows
        rowJ = XJ(n,:);
        
        % Get indices corresponding to valid data
        indices = (rowI > -50) & (rowJ > -50);
        num_elements = sum(indices);
        assert(num_elements > 0);
        I = rowI(indices);
        J = rowJ(indices);
        assert(all(isfinite(I)));
        assert(all(isfinite(J)));
        
        % Compute Euclidean distance normalized by the number of valid
        % elements
        d2(n) = sum(abs(I - J))/num_elements;
    end
