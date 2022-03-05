Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E7EC433F5
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Mar 2022 02:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiCECdu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Mar 2022 21:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCECdt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Mar 2022 21:33:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BEF234D00;
        Fri,  4 Mar 2022 18:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C266EB82C7D;
        Sat,  5 Mar 2022 02:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD9BC340E9;
        Sat,  5 Mar 2022 02:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646447578;
        bh=neY1T86Kge4jroZh/XlZk6gs9fQgr8OUUwRNLHilFwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X4WVG5X6Ij+LL4yYNPF148mH9KZ4yYsBIlN0lV+VPwCfGFKXAg8XdbA1ESbcrek9l
         j9peSsE7NS0dUX3EulMWvE7APStJvWzu/XtVBy60YuYbC4So2WHl99P6H95yZusiec
         pijnrbm3MVxk57t3Jv4FR6zbzlMddbDcsq+6H3Ck04FROWnutPgq9gb/CaYkzFQUCc
         /+KDEoWYnn3EiphkdWzWbpwkjmWr3ydhPq1OG+acr3OBs2XCRcjShOG/4uSOZlXacr
         Jid0x3prPV9d3cY1GUj5HzQa5rldDgvAFJJ5cjcSOevIDfIDsP8S7RQpRVAtFJiREl
         8uOBD/YwFGdBg==
Date:   Sat, 5 Mar 2022 04:32:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Nathaniel McCallum <nathaniel@profian.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: Add SGX_IOC_ENCLAVE_AUGMENT_PAGES
Message-ID: <YiLLrDure3canJYy@iki.fi>
References: <20220304122852.563475-1-jarkko@kernel.org>
 <94c4b8e2-1bf8-5a2a-7e76-6b8cad3c6b21@intel.com>
 <YiLISeGl1mpzY/09@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiLISeGl1mpzY/09@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Mar 05, 2022 at 04:17:53AM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 04, 2022 at 09:08:20AM -0800, Dave Hansen wrote:
> > On 3/4/22 04:28, Jarkko Sakkinen wrote:
> > > Explicit EAUG ioctl is a better choice than an implicit EAUG from a page
> > > fault handler because it allows to have O(1) number of kernel-enclave round
> > > trips for EAUG-EACCEPT{COPY} process, instead of O(n), as it is in the case
> > > when a page fault handler EAUG single page at a time.
> > 
> > So this is basically an optimization?  It's MADV_WILLNEED or
> > MAP_POPULATE to the cost of avoid future faults?
> 
> Yes.
> 
> So the idea would be that based on these the #PF handler would have more
> smartness, and it would do a batch of EAUG's?
> 
> That could be possibly acceptable but I also had other concern.
> 
> I would like to see this:
> 
> 1. Removal of vm_run_prot_bits.
> 2. Use RWX vm_max_prot_bits for EAUG'd pages.
> 
> During run-time kernel controls PTE's, and enclave has full control of the
> EPCM (EACCEPT, EACCEPTCOPY, EMODPE). By creating artificial limitations how
> to operate with these, it can limit various optimizations in the user space
> code. E.g. a syscall shim can require clever co-operation between in-enclave
> opcodes and what you do with the kernel in various situations.
> 
> RWX sounds provocative yes, but here it means only the limits where kernel
> can set its PTE's and nothing else, not that page table is filled with RWX
> pages, and enclave dictates what is in EPCM, and that's how it actually
> should be (e.g. you can sometimes deliver mmap() without ever going out
> of the enclave with EMODPE).
> 
> If MADV_WILLNEED/MAP_POPULATE approach is combined with this what I
> discussed here, then I think we could have solution to write an efficient
> memory management shims.

Do you already have a rough idea what needs to be done? I can take anyway a
look but just in case you had processed this further, please tell what you
have.

BR, Jarkko
