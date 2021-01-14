Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9995C433DB
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 04:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4239238E7
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 04:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbhANEoE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 23:44:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:36935 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbhANEoD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 23:44:03 -0500
IronPort-SDR: ym6HEfYrDiKpoHzjWHeIuwiDqMOjVUjtESiztHbqTefM1xQMo6sWzF1ls+8OFnJ0+Bu9sOjZwf
 SiGPWPJxrLjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="196958135"
X-IronPort-AV: E=Sophos;i="5.79,346,1602572400"; 
   d="scan'208";a="196958135"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 20:42:14 -0800
IronPort-SDR: wY/2orm4QfpyMhI+d+4ZM0i2QSFDFSkwXI4dsTWPSNjZXyh1ZPkcaJgFB6pCBy/7XPKH4VCJ84
 kmUDtgk+AlBg==
X-IronPort-AV: E=Sophos;i="5.79,346,1602572400"; 
   d="scan'208";a="353759711"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.251.157.39])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 13 Jan 2021 20:42:13 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Borislav Petkov" <bp@alien8.de>,
        "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org,
        "Sean Christopherson" <seanjc@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Jethro Beekman" <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic> <X/zoarV7gd/LNo4A@kernel.org>
Date:   Wed, 13 Jan 2021 22:42:12 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0w60mzepwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <X/zoarV7gd/LNo4A@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 11 Jan 2021 18:08:10 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Tue, Jan 05, 2021 at 03:57:49PM +0100, Borislav Petkov wrote:
>> On Wed, Dec 16, 2020 at 03:49:20PM +0200, Jarkko Sakkinen wrote:
>> > Add synchronize_srcu_expedited() to sgx_encl_release() to catch a  
>> grace
>> > period initiated by sgx_mmu_notifier_release().
>> >
>> > A trivial example of a failing sequence with tasks A and B:
>> >
>> > 1. A: -> sgx_release()
>> > 2. B: -> sgx_mmu_notifier_release()
>> > 3. B: -> list_del_rcu()
>> > 3. A: -> sgx_encl_release()
>> > 4. A: -> cleanup_srcu_struct()
>> >
>> > The loop in sgx_release() observes an empty list because B has  
>> removed its
>> > entry in the middle, and calls cleanup_srcu_struct() before B has a  
>> chance
>> > to calls synchronize_srcu().
>>
>> Leading to what? NULL ptr?
>>
>> https://lkml.kernel.org/r/X9e2jOWz1hfXVpQ5@google.com
>>
>> already suggested that you should explain the bug better and add the
>> splat but I'm still missing that explanation.
>
> OK, I'll try to explain it how I understand the issue.
>
> Consider this loop in the VFS release hook (sgx_release):
>
> 	/*
> 	 * Drain the remaining mm_list entries. At this point the list contains
> 	 * entries for processes, which have closed the enclave file but have
> 	 * not exited yet. The processes, which have exited, are gone from the
> 	 * list by sgx_mmu_notifier_release().
> 	 */
> 	for ( ; ; )  {
> 		spin_lock(&encl->mm_lock);
>
> 		if (list_empty(&encl->mm_list)) {
> 			encl_mm = NULL;
> 		} else {
> 			encl_mm = list_first_entry(&encl->mm_list,
> 						   struct sgx_encl_mm, list);
> 			list_del_rcu(&encl_mm->list);
> 		}
>
> 		spin_unlock(&encl->mm_lock);
>
> 		/* The enclave is no longer mapped by any mm. */
> 		if (!encl_mm)
> 			break;
>
> 		synchronize_srcu(&encl->srcu);
> 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> 		kfree(encl_mm);
> 	}
>
>
> At this point all processes have closed the enclave file, but that  
> doesn't
> mean that they all have exited yet.
>
> Now, let's imagine that there is exactly one entry in the encl->mm_list.
> and sgx_release() execution gets scheduled right after returning from
> synchronize_srcu().
>
> With some bad luck, some process comes and removes that last entry befoe
> sgx_release() acquires mm_lock. The loop in sgx_release() just leaves
>
> 		/* The enclave is no longer mapped by any mm. */
> 		if (!encl_mm)
> 			break;
>
> No synchronize_srcu().
>
> After writing this, I think that the placement for synchronize_srcu()
> in this patch is not best possible. It should be rather that the
> above loop would also call synchronize_srcu() when leaving.
>
> I.e. the code change would result:
>
> 	for ( ; ; )  {
> 		spin_lock(&encl->mm_lock);
>
> 		if (list_empty(&encl->mm_list)) {
> 			encl_mm = NULL;
> 		} else {
> 			encl_mm = list_first_entry(&encl->mm_list,
> 						   struct sgx_encl_mm, list);
> 			list_del_rcu(&encl_mm->list);
> 		}
>
> 		spin_unlock(&encl->mm_lock);
>
>                 /*
>                  * synchronize_srcu() is mandatory *even* when the list  
> was
>                  * empty, in order make sure that grace periods stays in
>                  * sync even when another task took away the last entry
>                  * (i.e. exiting process when it deletes its mm_list).
>                  */
> 		synchronize_srcu(&encl->srcu);
>
> 		/* The enclave is no longer mapped by any mm. */
> 		if (!encl_mm)
> 			break;
>
> 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> 		kfree(encl_mm);
> 	}
>
> What do you think? Does this start to make more sense now?
> I don't have logs for this but the bug can be also reasoned.
>
> /Jarkko

I did this experiment just now and find it runs much much slower than both  
original code and code with synchronize_srcu_expedited fix in this patch.
Haitao
