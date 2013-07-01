class AppDelegate
  def application(application,
                  didFinishLaunchingWithOptions:launchOptions)
    run_task_with_local_vars
  end

  #This is a asynchrous task that calls a block upon completion.
  #Imagine a network fetch or a Parse API call.
  def long_running_async_task(&block)
    gcdq = Dispatch::Queue.new('myqueue')
    gcdq.async {
      p 'Start'
      p 'running...'
      Random.rand(10)+10.times do
        1000.times do
          1000*1000
        end
      end
      p 'End, going to run completion block'
      block.call
      p 'After running completion block'
    }
  end

  def run_task_with_local_vars
    task_id =
      UIApplication.sharedApplication.
      beginBackgroundTaskWithExpirationHandler(proc {
      return if task_id == UIBackgroundTaskInvalid
    UIApplication.sharedApplication.endBackgroundTask(task_id)
    })

    long_running_async_task do
      p 'In block'
      p "In block with task_id #{task_id}"
      if task_id != UIBackgroundTaskInvalid
        p "End task with #{task_id}"
        UIApplication.sharedApplication.endBackgroundTask(task_id)
      end
    end
    
    p '#run_task_with_local_vars returned'
  end
end
