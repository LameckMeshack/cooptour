defmodule CooptourWeb.CompanyLive.Index do
  use CooptourWeb, :live_view

  alias Cooptour.Corporate

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="px-40 flex flex-1 justify-center ">
        <div class="layout-content-container flex flex-col w-[512px] max-w-[512px]  max-w-[960px] flex-1">
          <div class="flex flex-wrap justify-between gap-3 p-4">
            <p class="text-[#111418] tracking-light text-[32px] font-bold leading-tight min-w-72">
              Create your company
            </p>
          </div>
          <div class="flex max-w-[480px] flex-wrap items-end gap-4 px-4 py-3">
            <label class="flex flex-col min-w-40 flex-1">
              <p class="text-[#111418] text-base font-medium leading-normal pb-2">Company name</p>
              <input
                placeholder="Enter company name"
                class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-xl text-[#111418] focus:outline-0 focus:ring-0 border-none bg-[#eaedf0] focus:border-none h-14 placeholder:text-[#5e7387] p-4 text-base font-normal leading-normal"
                value=""
              />
            </label>
          </div>
          <div class="flex max-w-[480px] flex-wrap items-end gap-4 px-4 py-3">
            <label class="flex flex-col min-w-40 flex-1">
              <p class="text-[#111418] text-base font-medium leading-normal pb-2">Main location</p>
              <input
                placeholder="Enter main location"
                class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-xl text-[#111418] focus:outline-0 focus:ring-0 border-none bg-[#eaedf0] focus:border-none h-14 placeholder:text-[#5e7387] p-4 text-base font-normal leading-normal"
                value=""
              />
            </label>
          </div>
          <div class="flex max-w-[480px] flex-wrap items-end gap-4 px-4 py-3">
            <label class="flex flex-col min-w-40 flex-1">
              <p class="text-[#111418] text-base font-medium leading-normal pb-2">Contact email</p>
              <input
                placeholder="Enter contact email"
                class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-xl text-[#111418] focus:outline-0 focus:ring-0 border-none bg-[#eaedf0] focus:border-none h-14 placeholder:text-[#5e7387] p-4 text-base font-normal leading-normal"
                value=""
              />
            </label>
          </div>
          <div class="flex max-w-[480px] flex-wrap items-end gap-4 px-4 py-3">
            <label class="flex flex-col min-w-40 flex-1">
              <p class="text-[#111418] text-base font-medium leading-normal pb-2">Contact phone</p>
              <input
                placeholder="Enter contact phone"
                class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-xl text-[#111418] focus:outline-0 focus:ring-0 border-none bg-[#eaedf0] focus:border-none h-14 placeholder:text-[#5e7387] p-4 text-base font-normal leading-normal"
                value=""
              />
            </label>
          </div>

          <div class="flex px-4 py-3">
            <button class="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-xl h-10 px-4 flex-1 bg-[#b8cee4] text-[#111418] text-sm font-bold leading-normal tracking-[0.015em]">
              <span class="truncate">Create company</span>
            </button>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    Corporate.subscribe_companies(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Listing Companies")
     |> stream(:companies, Corporate.list_companies(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Corporate.get_company!(socket.assigns.current_scope, id)
    {:ok, _} = Corporate.delete_company(socket.assigns.current_scope, company)

    {:noreply, stream_delete(socket, :companies, company)}
  end

  @impl true
  def handle_info({type, %Cooptour.Corporate.Company{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :companies, Corporate.list_companies(socket.assigns.current_scope),
       reset: true
     )}
  end
end
