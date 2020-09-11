Return-Path: <SRS0=Q2gl=CU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD49C43461
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 17:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CAC221E7
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 17:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgIKRjc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:39:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:33320 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgIKRjE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Sep 2020 13:39:04 -0400
IronPort-SDR: Lyim0VwtsE8zQMvI6uE5qd+kJLWEvfKE6UyDTcLKFRY2Qy/1pF9XmOkXTzPNX89y7NJnR4BZqX
 Slhlf5JGDB4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="146547173"
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="146547173"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 10:39:01 -0700
IronPort-SDR: AE+W1pepn2Ws8YLY5NNGEkcjAeyXCQhF3fKr2bI9nEeTXgYg1p3qOp2BhPNm2IdjP6obHm18Wt
 8FYo8OjZ4JqA==
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="481401026"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.255.38.177])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 11 Sep 2020 10:39:00 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, "Borislav Petkov" <bp@suse.de>
Subject: Re: [PATCH] x86/sgx: Roof the number of pages process in
 SGX_IOC_ENCLAVE_ADD_PAGES
References: <20200908190042.24895-1-jarkko.sakkinen@linux.intel.com>
 <20200909053033.GC9987@sjchrist-ice> <20200911114315.GA6760@linux.intel.com>
 <20200911155125.GA4344@sjchrist-ice>
Date:   Fri, 11 Sep 2020 12:38:59 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0qsja9jawjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20200911155125.GA4344@sjchrist-ice>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

nOn Fri, 11 Sep 2020 10:51:27 -0500, Sean Christopherson  
<sean.j.christopherson@intel.com> wrote:

> On Fri, Sep 11, 2020 at 02:43:15PM +0300, Jarkko Sakkinen wrote:
>> On Tue, Sep 08, 2020 at 10:30:33PM -0700, Sean Christopherson wrote:
>> > >  	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
>> > > -		if (signal_pending(current)) {
>> > > -			ret = -EINTR;
>> > > +		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
>> > > +			ret = c;
>> >
>> > I don't have an opinion on returning count vs. EINTR, but I don't see  
>> the
>> > point in arbitrarily capping the number of pages that can be added in  
>> a
>> > single ioctl().  It doesn't provide any real protection, e.g.  
>> userspace
>> > can simply restart the ioctl() with updated offsets and continue  
>> spamming
>> > EADDs.  We are relying on other limits, e.g. memcg, rlimits, etc... to
>> > reign in malicious/broken userspace.
>> >
>> > There is nothing inherently dangerous about spending time in the  
>> kernel so
>> > long as appropriate checks are made, e.g. for a pending signel and  
>> resched.
>> > If we're missing checks, adding an arbitrary limit won't fix the  
>> underlying
>> > problem, at least not in a deterministic way.
>> >
>> > If we really want a limit of some form, adding a knob to control the  
>> max
>> > size of an enclave seems like the way to go.  But even that is of  
>> dubious
>> > value as I'd rather rely on existing limits for virtual and physical  
>> memory,
>> > and add a proper EPC cgroup to account and limit EPC memory.
>>
>> It is better to have a contract in the API that the number of processed
>> pages can be less than given, not unlike in syscalls such as write().
>
> That can be handled by a comment, no?  If we want to "enforce" the  
> behavior,
> I'd rather bail out of the loop after a random number of pages than have  
> a
> completely arbitrary limit.  The arbitrary limit will create a contract  
> of
> its own and may lead to weird guest implementations.


I agree with Sean on potential issues with the arbitrary hard coded limit.  
Also returning -EINTR is better way to express to user space that  
operations are interrupted by signal and can be retried, which is a known  
pattern for this kind of situations.
