Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C64DC433F5
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Jan 2022 19:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiAVTPF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 22 Jan 2022 14:15:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:64395 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbiAVTPE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 22 Jan 2022 14:15:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642878904; x=1674414904;
  h=cc:references:subject:to:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=tm2pQlSjghJq/urFWSMM+I1PhbNtArTasdhNBef54RE=;
  b=ao0EycBD+2rIagxAdQR8hg7i3I/ZMn9UaHqYCw5xSZc/r0NV1PFs4DJT
   zsth1+EIQ/GTIp1WJ+ilCJzfwDDmrIk+v6+ts9znMB4ZlvK308oHwkkFx
   qUQ7Qv/IOPaxCihKu7FKAHGhgHpW40hjM7Bc9FJ86MV2wNlq9/oevkf1B
   l0qj9iW9H1zD7H/MpepisxS76+CaTWFP9OJxuvymvBIqDrNRE11LzTwzQ
   4MmV3Gk0t3F+pewhfCHBWd1APSgafGXzSRRcyUJDEaBZfoBDOs5xRoJQ/
   Bk6C1etm5kLMyrFa/BS4oGF/1hymDAOy3VX7DjLLkfhe5leOaW0KbGCoM
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="233199948"
X-IronPort-AV: E=Sophos;i="5.88,308,1635231600"; 
   d="scan'208";a="233199948"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2022 11:15:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,308,1635231600"; 
   d="scan'208";a="533697231"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.255.35.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 22 Jan 2022 11:15:03 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Cc:     "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
Subject: Re: Testing 5.17 bugfix material
To:     "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Dave Hansen" <dave.hansen@intel.com>
Date:   Sat, 22 Jan 2022 13:15:01 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1gevpaxgwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On Fri, 21 Jan 2022 13:57:50 -0600, Dave Hansen <dave.hansen@intel.com>
wrote:

> Hi Everyone,
>
> There are a few SGX fixes that have showed up in the last week or so,
> mostly around RAS and fixing the backing storage issues.  Could folks
> please give this branch a good thrashing?
>
>> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
>
> I'm planning to send this bunch up to Linus after 5.17-rc1 comes out.
>
> Kristen, I really dug into the changelogs of your two patches to make it
> more clear that they are bugfix and stable@ material.  I'd appreciate
> some additional eyeballs there.

When testing this with a large enclave loaded by Intel runtime, we saw it  
hang
on EADD ioctl and the ioctl never returns.

Also noticed the selftest fails on oversub but the return errno is EINTR  
not
ENOMEM as expected.

When user space register signal handler with SA_RESTART flag, EINTR would
be an auto restart of ioctl. So that might be what's going on with Intel
runtime test. And I suspect following code may cause infinite restart of  
the
ioctl:

struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
{
       struct sgx_epc_page *page;

       for ( ; ; ) {
           page = __sgx_alloc_epc_page();
           if (!IS_ERR(page)) {
               page->owner = owner;
               break;
           }

           if (list_empty(&sgx_active_page_list))<-- should also check
sgx_nr_available_backing_pages?
               return ERR_PTR(-ENOMEM);

           if (!reclaim) {
               page = ERR_PTR(-EBUSY);
               break;
           }

           if (signal_pending(current)) {
               page = ERR_PTR(-ERESTARTSYS);<---- this is the only exit of
the for loop when backing store limit reaches.
               break;
           }

           sgx_reclaim_pages(); <---- no checking for backing store fail due
to limit here.
           cond_resched();
       }

Thanks
Haitao
