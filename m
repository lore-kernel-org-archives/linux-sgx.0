Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9366C4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 17:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948BA2255F
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 17:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgLORiX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:38:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:28738 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729872AbgLORiV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Dec 2020 12:38:21 -0500
IronPort-SDR: 7U6eQFNS54zDZBWDual6DAu2O5iwZCPr3eUpKdphKAxSGBoDAVXPFjsaVUTRl1rWyMmOvnJb36
 R471IEqaYpwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="236501084"
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="236501084"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 09:34:42 -0800
IronPort-SDR: 9aJtE6tgrqJppVDV1P/DysFoTXr0DxJA9MHagWgtvZMlgWhZ51qOy8ZHXdVvRtg+EqPlbOsTI4
 X2z8YbNw/4pA==
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="487967086"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO fgctuval.land.test) ([10.212.2.91])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 15 Dec 2020 09:34:41 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>
In-Reply-To: <20201215055955.GA28511@kernel.org>
Organization: Intel Corp
References: <20201211113230.28909-1-jarkko@kernel.org>
 <X9e2jOWz1hfXVpQ5@google.com> <20201215055556.GA28278@kernel.org>
 <20201215055955.GA28511@kernel.org>
Subject: Re: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
To:     "Sean Christopherson" <seanjc@google.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Date:   Tue, 15 Dec 2020 11:34:37 -0600
Message-ID: <op.0vogfzwvwjvjmi@fgctuval.land.test>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 14 Dec 2020 23:59:55 -0600, Jarkko Sakkinen <jarkko@kernel.org>
wrote:

> On Tue, Dec 15, 2020 at 07:56:01AM +0200, Jarkko Sakkinen wrote:
>> On Mon, Dec 14, 2020 at 11:01:32AM -0800, Sean Christopherson wrote:
>> > On Fri, Dec 11, 2020, Jarkko Sakkinen wrote:
>> > > Each sgx_mmun_notifier_release() starts a grace period, which means  
>> that
>> >
>> > Should be sgx_mmu_notifier_release(), here and in the comment.
>>
>> Thanks.
>>
>> > > one extra synchronize_rcu() in sgx_encl_release(). Add it there.
>> > >
>> > > sgx_release() has the loop that drains the list but with bad luck  
>> the
>> > > entry is already gone from the list before that loop processes it.
>> >
>> > Why not include the actual analysis that "proves" the bug?  The splat  
>> that
>> > Haitao reported would also be useful info.
>>
>> True. I can include a snippet of dmesg to the commit message.
>>
>> > > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
>> > > Cc: Borislav Petkov <bp@alien8.de>
>> > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> > > Reported-by: Sean Christopherson <seanjc@google.com>
>> >
>> > Haitao reported the bug, and for all intents and purposes provided  
>> the fix.  I
>> > just did the analysis to verify that there was a legitimate bug and  
>> that the
>> > synchronization in sgx_encl_release() was indeed necessary.
>>
>> Good and valid point. The way I see it, the tags should be:
>>
>> Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>
>> Haitao pointed out the bug but from your analysis I could resolve that
>> this is the fix to implement, and was able to write the long
>> description for the commit.
>>
>> Does this make sense to you?
>
> I'm sending v2 next week (this week on vacation).
>
> /Jarkko

I don't mind either how tags are assigned. But our testing reveals
significant latency introduced in scenarios of heavy loading/unloading
enclaves. synchronize_srcu_expedited fixed the issue. Please analyze and
confirm if that's more appropriate than synchronize_srcu here.
