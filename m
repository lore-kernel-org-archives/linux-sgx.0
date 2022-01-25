Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D78C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jan 2022 05:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S255366AbiAYFPi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:15:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:54419 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S254456AbiAYEhU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Jan 2022 23:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643085438; x=1674621438;
  h=cc:references:subject:to:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=g5Wsb8JqDziI1XzBhCw7FtBzJrmJW77OaD+5JXi7rp0=;
  b=DFyuwzwmguTKvX4Dh7oNJj0nQ4w21sqV500/f24lbmQAdQG+t+TvRJCA
   sEmsLO3ljU4D/wWWjEDxXIWNXkWtSXboZNjXVTteO2SWa/cAxjDiQKJmy
   S0e530idfIkgR7BDgbHm405kzGvht4UolisHq3vLw5wEFQoSGJziQcIc9
   qPeNJldv53r/GgTdtfmalXRjQ0JWHr87CXlXeMNpzkfpKqwR0bTFUGknO
   W+yR48e0dw58t7zL6phAisqrgpiRUFeG2INP6BPr5WzpempZVdmWEhFiu
   F83iEIsMU7/8/DbfPwwrEhJT49UVfDb7Bml4i+g9xG8sGx8Ymo2RGdW5j
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="233583746"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="233583746"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 20:27:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="534555139"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.255.33.35])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 24 Jan 2022 20:27:21 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Cc:     "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
 <op.1gevpaxgwjvjmi@hhuan26-mobl1.mshome.net> <Ye7k7b1x8OnQcJgL@iki.fi>
 <Ye7n/vk+MNF3Nc1D@iki.fi>
Subject: Re: Testing 5.17 bugfix material
To:     "Jarkko Sakkinen" <jarkko@kernel.org>
Date:   Mon, 24 Jan 2022 22:27:20 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1gjamonzwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <Ye7n/vk+MNF3Nc1D@iki.fi>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 24 Jan 2022 11:55:10 -0600, Jarkko Sakkinen <jarkko@kernel.org>
wrote:

> On Mon, Jan 24, 2022 at 07:42:08PM +0200, Jarkko Sakkinen wrote:
>> On Sat, Jan 22, 2022 at 01:15:01PM -0600, Haitao Huang wrote:
>> > Hi Dave,
>> >
>> > On Fri, 21 Jan 2022 13:57:50 -0600, Dave Hansen  
>> <dave.hansen@intel.com>
>> > wrote:
>> >
>> > > Hi Everyone,
>> > >
>> > > There are a few SGX fixes that have showed up in the last week or  
>> so,
>> > > mostly around RAS and fixing the backing storage issues.  Could  
>> folks
>> > > please give this branch a good thrashing?
>> > >
>> > > >  
>> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
>> > >
>> > > I'm planning to send this bunch up to Linus after 5.17-rc1 comes  
>> out.
>> > >
>> > > Kristen, I really dug into the changelogs of your two patches to  
>> make it
>> > > more clear that they are bugfix and stable@ material.  I'd  
>> appreciate
>> > > some additional eyeballs there.
>> >
>> > When testing this with a large enclave loaded by Intel runtime, we  
>> saw it
>> > hang
>> > on EADD ioctl and the ioctl never returns.
>> >
>> > Also noticed the selftest fails on oversub but the return errno is  
>> EINTR not
>> > ENOMEM as expected.
>> >
>> > When user space register signal handler with SA_RESTART flag, EINTR  
>> would
>> > be an auto restart of ioctl. So that might be what's going on with  
>> Intel
>> > runtime test. And I suspect following code may cause infinite restart  
>> of the
>> > ioctl:
>> >
>> > struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>> > {
>> >       struct sgx_epc_page *page;
>> >
>> >       for ( ; ; ) {
>> >           page = __sgx_alloc_epc_page();
>> >           if (!IS_ERR(page)) {
>> >               page->owner = owner;
>> >               break;
>> >           }
>> >
>> >           if (list_empty(&sgx_active_page_list))<-- should also check
>> > sgx_nr_available_backing_pages?
>> >               return ERR_PTR(-ENOMEM);
>
> I don't think so but why do you think it should?

I was thinking no point to continue if
(atomic_long_read(&sgx_nr_available_backing_pages)==0).
We just failed on finding available EPC above in __sgx_alloc_epc_page. So  
if we can't swap, then nothing we can do, right?

BR
Haitao
