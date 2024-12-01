program main
   use stdlib_sorting, only: sort
   implicit none

   integer, dimension(:), allocatable :: left_list, right_list
   integer :: total_distance, total_similarity
   integer :: n, i
   character(len=100) :: filename
   character(len=50) :: line
   integer :: unit, ios

   call get_command_argument(1, filename)

   if (trim(adjustl(filename)) == "") then
      print *, "Usage: ./program_name <filename>"
      stop
   end if

   open(newunit=unit, file=filename, status='old', action='read', iostat=ios)
   if (ios /= 0) then
      print '(A)', 'Error opening file!'
      stop
   end if

   n = 0
   do
      read(unit, *, iostat=ios)
      if (ios /= 0) exit
      n = n + 1
   end do
   rewind(unit)

   allocate(left_list(n), right_list(n))

   do i = 1, n
      read(unit, *, iostat=ios) left_list(i), right_list(i)
      if (ios /= 0) then
         print '(A)', "Error: Malformed input at line ", i
         stop
      end if
   end do

   close(unit)

   call sort(left_list)
   call sort(right_list)

   print *, "Part 1:", sum(abs(left_list - right_list))

   total_similarity = 0
   do i = 1, n
      total_similarity = &
         total_similarity + left_list(i) * count(right_list == left_list(i))
   end do

   print *, "Part 2:", total_similarity

   deallocate(left_list, right_list)
end program main
