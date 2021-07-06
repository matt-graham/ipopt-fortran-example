! Non-linear program problem 71 from the Hock-Schittkowski test suite:
!
!     minimize
!         f(x) = x(1) * x(4) * (x(1) + x(2) + x(3)) + x(3)
!     subject to
!         x(1) * x(2) * x(3) * x(4) >= 25,
!         x(1)**2 + x(2)**2 + x(3)**2 + x(4)**2 - 40 = 0
!         1 <= x(1), x(2), x(3), x(4) <= 5
!
! Starting point: x = (1, 5, 5, 1)
! Optimal solution: x = (1.00000000, 4.74299963, 3.82114998, 1.37940829)

module problem71

  use, intrinsic :: iso_fortran_env, dp => real64

  implicit none

  ! Number of variables
  integer, parameter :: size_x = 4

  ! Number of equality constraints
  integer, parameter :: size_g = 2

  ! Number of non-zero elements in constraint Jacobian
  integer, parameter :: nonzero_jacob_g = 8

  ! Number of non-zero elements in Lagrangian Hessian
  integer, parameter :: nonzero_hess_l = 10

  ! Base for row and column indices in triplet sparse matrix format
  integer, parameter :: index_base = 1

  ! Initial point
  real(dp), parameter :: x_init(size_x) = [1d0, 5d0, 5d0, 1d0]

  ! Bounds for optimization variables
  real(dp), parameter :: x_lower(size_x) = [1d0, 1d0, 1d0, 1d0]
  real(dp), parameter :: x_upper(size_x) = [5d0, 5d0, 5d0, 5d0]

  ! Bounds for the constraints
  real(dp), parameter :: g_lower(size_g) = [25d0, 40d0]
  real(dp), parameter :: g_upper(size_g) = [1d40, 40d0]

  contains

  subroutine eval_objective( &
    size_x, x, x_is_new, f, int_data, real_data, error_code &
  )
    ! Evaluate objective function
    integer, intent(in) :: size_x
    real(dp), intent(in) :: x(size_x)
    integer, intent(in) :: x_is_new
    real(dp), intent(out) :: f
    integer, intent(in) :: int_data(:)
    real(dp), intent(in) :: real_data(:)
    integer, intent(out) :: error_code
    f = x(1) * x(4) * (x(1) + x(2) + x(3)) + x(3)
    error_code = 0
  end subroutine

  subroutine eval_grad_objective( &
    size_x, x, x_is_new, grad_f, int_data, real_data, error_code &
  )
    ! Evaluate gradient of objective function
    integer, intent(in) :: size_x
    real(dp), intent(in) :: x(size_x)
    integer, intent(in) :: x_is_new
    real(dp), intent(out) :: grad_f(size_x)
    integer, intent(in) :: int_data(:)
    real(dp), intent(in) :: real_data(:)
    integer, intent(out) :: error_code
    grad_f(1) = x(4) * (2 * x(1) + x(2) + x(3))
    grad_f(2) = x(1) * x(4)
    grad_f(3) = x(1) * x(4) + 1
    grad_f(4) = x(1) * (x(1) + x(2) + x(3))
    error_code = 0
  end subroutine

  subroutine eval_constraint( &
    size_x, x, x_is_new, size_g, g, int_data, real_data, error_code &
  )
    ! Evaluate equality constraint function
    integer, intent(in) :: size_x
    real(dp), intent(in) :: x(size_x)
    integer, intent(in) :: x_is_new
    integer, intent(in) :: size_g
    real(dp), intent(out) :: g(size_g)
    integer, intent(in) :: int_data(:)
    real(dp), intent(in) :: real_data(:)
    integer, intent(out) :: error_code
    g(1) = x(1) * x(2) * x(3) * x(4)
    g(2) = x(1)**2 + x(2)**2 + x(3)**2 + x(4)**2
    error_code = 0
  end subroutine

  subroutine eval_jacob_constraint( &
    task, size_x, x, x_is_new, size_g, nonzero_jacob_g, jacob_g_col, jacob_g_row, &
    jacob_g_val, int_data, real_data, error_code &
  )
    ! Evaluate Jacobian of equality constraint function
    integer, intent(in) :: task
    integer, intent(in) :: size_x
    real(dp), intent(in) :: x(size_x)
    integer, intent(in) :: x_is_new
    integer, intent(in) :: size_g
    integer, intent(in) :: nonzero_jacob_g
    integer, intent(out) :: jacob_g_col(nonzero_jacob_g)
    integer, intent(out) :: jacob_g_row(nonzero_jacob_g)
    real(dp), intent(out) :: jacob_g_val(nonzero_jacob_g)
    integer, intent(in) ::  int_data(:)
    real(dp), intent(in) :: real_data(:)
    integer, intent(out) :: error_code

    if (task == 0) then
      jacob_g_row = [1, 2, 3, 4, 1, 2, 3, 4]
      jacob_g_col = [1, 1, 1, 1, 2, 2, 2, 2]
    else
      jacob_g_val(1) = x(2) * x(3) * x(4)
      jacob_g_val(2) = x(1) * x(3) * x(4)
      jacob_g_val(3) = x(1) * x(2) * x(4)
      jacob_g_val(4) = x(1) * x(2) * x(3)
      jacob_g_val(5) = 2 * x(1)
      jacob_g_val(6) = 2 * x(2)
      jacob_g_val(7) = 2 * x(3)
      jacob_g_val(8) = 2 * x(4)
    end if
    error_code = 0
  end subroutine

  subroutine eval_hess_lagrangian( &
    task, size_x, x, x_is_new, sigma, size_g, lambda, lambda_is_new, nonzero_hess_l, &
    hess_l_row, hess_l_col, hess_l_val, int_data, real_data, error_code &
  )
    ! Evaluate Hessian of Lagrangian
    integer, intent(in) :: task
    integer, intent(in) :: size_x
    real(dp), intent(in) :: x(size_x)
    integer, intent(in) :: x_is_new
    real(dp), intent(in) :: sigma
    integer, intent(in) :: size_g
    real(dp), intent(in) :: lambda(size_g)
    integer, intent(in) :: lambda_is_new
    integer, intent(in) :: nonzero_hess_l
    integer, intent(out) :: hess_l_row(nonzero_hess_l)
    integer, intent(out) :: hess_l_col(nonzero_hess_l)
    real(dp), intent(out) :: hess_l_val(nonzero_hess_l)
    integer, intent(in) ::  int_data(:)
    real(dp), intent(in) :: real_data(:)
    integer, intent(out) :: error_code

    if (task == 0) then
      hess_l_row = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
      hess_l_col = [1, 1, 2, 1, 2, 3, 1, 2, 3, 4]
    else
      hess_l_val(1) = sigma * 2 * x(4) + lambda(2) * 2
      hess_l_val(2) = sigma * x(4) + lambda(1) * x(3) * x(4)
      hess_l_val(3) = lambda(2) * 2
      hess_l_val(4) = sigma * x(4) + lambda(1) * x(2) * x(4)
      hess_l_val(5) = lambda(1) * x(1) * x(4)
      hess_l_val(6) = lambda(2) * 2
      hess_l_val(7) = sigma * (2 * x(1) + x(2) + x(3)) + lambda(1) * x(2) * x(3)
      hess_l_val(8) = sigma * x(1) + lambda(1) * x(1) * x(3)
      hess_l_val(9) = sigma * x(1) + lambda(1) * x(1) * x(2)
      hess_l_val(10) = lambda(2) * 2
    end if
    error_code = 0
  end subroutine

end module