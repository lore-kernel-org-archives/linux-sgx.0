Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D62C433E9
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Jan 2021 18:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123832376F
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Jan 2021 18:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbhAVSjg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Jan 2021 13:39:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:52349 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbhAVSWx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Jan 2021 13:22:53 -0500
IronPort-SDR: F0X181gO3IgYuhlwLztNYdTDYiZ4uTrgpAYy3m2QkTqUI8kMUXZVHB3N2EecHlCh98Zo9YoCCP
 QINPJJNt5oYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="175975562"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="175975562"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 10:21:03 -0800
IronPort-SDR: IwZA0NZao4cRQlPMucSq74q6vlDjUHqkewQAzWTtoBBanWU2EWgFE5ssJnkPmB2ZbiZEHkyjD4
 rjv25oktYxJw==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="407866180"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.213.188.87])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 22 Jan 2021 10:21:01 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Dave Hansen" <dave.hansen@intel.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     "Borislav Petkov" <bp@alien8.de>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, haitao.huang@intel.com, seanjc@google.com,
        stable@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jethro Beekman" <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
References: <20210115014638.15037-1-jarkko@kernel.org>
 <20210115071809.GA9138@zn.tnic> <YAJ11v5tuS2uMuNm@kernel.org>
 <20210118185712.GE30090@zn.tnic> <YAhBeaItbqYmf0oF@kernel.org>
 <bb46fd98-0f67-76a7-9ba9-3a646c2a8f84@intel.com> <YAjKUO+nI2pJs1HD@kernel.org>
Date:   Fri, 22 Jan 2021 12:20:59 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0xmvr1urwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <YAjKUO+nI2pJs1HD@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 20 Jan 2021 18:26:56 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Wed, Jan 20, 2021 at 09:34:10AM -0800, Dave Hansen wrote:
>> On 1/20/21 6:43 AM, Jarkko Sakkinen wrote:
>> >> So why do you need the synchronize_srcu() call when this process  
>> sees an
>> >> empty mm_list already?
>> >>
>> >> Thx.
>> > The other process aka some process using the enclave calls  
>> list_del_rcu()
>> > (and synchronize_srcu()), which starts a new grace period. If we don't
>> > do it, then the cleanup_srcu() will race with that grace period.
>>
>> To me, this is only a partial explanation.
>>
>> That goal of synchronize_srcu() is to wait for the completion of a
>> *previous* grace period: one that might have observed the old state of
>> the list.
>>
>> Could you explain the *actual* effects of the misplaced
>> synchronize_srcu()?  If the race _occurs_, what is the side-effect?
>
> As I haven't been able to reproduce this regression myself, I need
> to take steps back and try to reproduce the it with Graphene.
>
> WARN_ON()'s trigger inside cleanup_srcu_struct(), which causes a memory
> leak since free_percpu() gets never called. If I recall correctly, it
> was srcu_readers_active() but unfortunately I don't have a log available.
>
> Perhaps Haitao could provide us one.
>
> /Jarkko

Sorry I lost those logs too as our email server automatically clean up old  
emails. I have been re-running the tests but have not been able to  
reproduce the same issue.

Haitao
