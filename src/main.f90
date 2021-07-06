! Example of using Ipopt to solve non-linear program

program main

  use, intrinsic :: iso_fortran_env, dp => real64

  ! Definitions corresponding to problem 71 from the Hock-Schittkowski test suite
  use problem71

  implicit none

  ! Objective value
  real(dp) :: f

  ! Equality constraints
  real(dp) :: g(size_g)

  ! Lagrange multipliers for equality constraints
  real(dp) :: lambda(size_g)

  ! Variables to be optimized over
  real(dp) :: x(size_x)

  ! Lagrange multipliers for lower and upper inequality constraints
  real(dp) :: z_lower(size_x), z_upper(size_x)

  ! Private data for evaluation routines
  real(dp) :: real_data(1)
  integer :: int_data(1)

  ! Ipopt problem handle (integer kind platform specific)
  integer(int64) :: iproblem

  ! External Ipopt function to create problem (integer kind platform specific)
  integer(int64), external :: ipcreate

  ! Integer error code returned by Ipopt functions
  integer :: error_code

  ! Additional external Ipopt functions
  integer, external :: ipsolve, ipopenoutputfile
  integer, external :: ipaddstroption, ipaddnumoption, ipaddintoption

  ! Dummy index for iterating over arrays
  integer :: i

  ! First create a handle for the Ipopt problem (and read the options file)
  iproblem = ipcreate( &
    size_x, x_lower, x_upper, size_g, g_lower, g_upper, nonzero_jacob_g, &
    nonzero_hess_l, index_base, eval_objective, eval_constraint, eval_grad_objective, &
    eval_jacob_constraint, eval_hess_lagrangian &
  )
  if (iproblem == 0) then
    stop 'Error creating an Ipopt problem handle.'
  endif

  ! Open an output file
  error_code = ipopenoutputfile(iproblem, 'output/ipopt.out', 12)
  if (error_code /= 0) then
    call ipfree(iproblem)
    stop 'Error opening the Ipopt output file. Ensure output directory exists.'
  end if

  ! Note: The following options are only examples, they might not be suitable for your
  ! optimization problem.

  ! Set a string option
  error_code = ipaddstroption(iproblem, 'mu_strategy', 'adaptive')
  if (error_code /= 0) then
    call ipfree(iproblem)
    stop 'Error setting a string option.'
  end if

  ! Set an integer option
  error_code = ipaddintoption(IPROBLEM, 'print_level', 0)
  if (error_code /= 0) then
    call ipfree(iproblem)
    stop 'Error setting an integer option.'
  end if

  ! Set a real numeric option
  error_code = ipaddnumoption(iproblem, 'tol', 1d-8)
  if (error_code /= 0) then
    call ipfree(iproblem)
    stop 'Error setting a numeric option.'
  end if

  ! Call optimization routine
  x = x_init
  error_code = ipsolve(iproblem, x, g, f, lambda, z_lower, z_upper, int_data, real_data)

  ! Print output
  if (error_code == 0) then
    print '(A)', 'The solution was found.'
    print '(A,F12.9)', 'The final value of the objective function is ', f
    print '(A)', 'The optimal values of x are:'
    do i = 1, size_x
      print '(A,I0,A,F12.9)', '        x(', i, ') = ', x(i)
    end do
    print '(A)', 'The multipliers for the lower bounds are:'
    do i = 1, size_x
      print '(A,I0,A,F12.9)', '  z_lower(', i, ') = ', z_lower(i)
    end do
    print '(A)', 'The multipliers for the upper bounds are:'
    do i = 1, size_x
      print '(A,I0,A,F12.9)', '  z_upper(', i, ') = ', z_upper(i)
    end do
    print '(A)', 'The multipliers for the equality constraints are:'
    do i = 1, size_g
      print '(A,I0,A,F12.9)', '   lambda(', i, ') = ', lambda(i)
    end do
  else
    print '(A)', 'An error occured.'
    print '(A,I0)', 'The error code is ', error_code
  end if

end program