Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE73C7618A
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Mar 2023 14:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCTOEp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Mar 2023 10:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjCTOEm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 20 Mar 2023 10:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC4D196AB
        for <linux-sgx@vger.kernel.org>; Mon, 20 Mar 2023 07:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3BA46151A
        for <linux-sgx@vger.kernel.org>; Mon, 20 Mar 2023 14:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3BBC433EF;
        Mon, 20 Mar 2023 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679321071;
        bh=8lvwaZJUnbF0MvLJnocMqb9nzNKaStmJrZswD5dR838=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ea6d1lSHPHbz3UlxpzVhihcyiGRZz051t7xYN8jd6yUKZ1FKsl/527ksxHJ6ysAnc
         umRV7UmK2TJcXChdfMiikUXKRGDi8FgFpeOioaMq77iGsYz6qMMn7FUIzmbc6EDUQe
         27Kx3ZMmZ/J3CHwCeWVGu7M5KbCz7OCYWXfu2WMTdlEPRrHFrVWurzs1a1nEaWBegr
         OTqG1ipG+faOqQUMF52aAfgRllpJbfcxfq/xJCqNnLW3jUF/NzkTugK6j45Ka1tWD6
         8B7sl/+CmK8emN3KV2MDR6YFuOx0QEtKa3cdJcbzzSLsG6BaOBArh34nFhuYQsL1tC
         5vH7zJnOUqyfg==
Date:   Mon, 20 Mar 2023 16:04:27 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <20230320140427.7szduipk2s5qzr4j@kernel.org>
References: <Y/AAbC/j04aUkd8R@kernel.org>
 <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/VBOkmi7VbVuzAh@kernel.org>
 <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
 <op.11sw04rxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <20230319132606.yatircsujyj6got5@kernel.org>
 <3766cb40f79b9fb931e3b254c01e45f56e2777e1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3766cb40f79b9fb931e3b254c01e45f56e2777e1.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 20, 2023 at 09:36:14AM +0000, Huang, Kai wrote:
> On Sun, 2023-03-19 at 15:26 +0200, jarkko@kernel.org wrote:
> > On Tue, Mar 14, 2023 at 09:54:30AM -0500, Haitao Huang wrote:
> > > On Thu, 09 Mar 2023 05:31:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:
> > > > > 
> > > > > Then in v29, PROT_NONE mapping was disallowed for encl_fd before pages
> > > > > EADDed so user space has to mmap anonymously to reserve the range.The
> > > > > intent was still not to allow mmap before pages EADDed (the !page check
> > > > > was still there up to v38)
> > > > 
> > > > Do you know the reason of disallowing PROT_NONE mapping against encl_fd?
> > > > 
> > > 
> > > I think it was to allow user space to do anonymous mapping to reserve
> > > address space for enclave.
> > > Before this point, you have to use PROT_NONE to reserve with encl_fd. There
> > > might be an issue with how #PF and EPC swapping was handled or the elegance
> > > of those flows that motivated the move but I can't remember. ABI was not
> > > fixed at that time so it was OK to change.
> > 
> > Yes, this was done because enclave naturally aligned base address.
> > 
> > 
> 
> Sorry for being ignorant, but you can also get the aligned base address via
> mmap() against encl_fd, correct?  What is the fundamental difference between
> mmap(MAP_ANONYMOUS) vs mmap(encl_fd)?

This is what we do atm:

static unsigned long sgx_get_unmapped_area(struct file *file,
                                           unsigned long addr,
                                           unsigned long len,
                                           unsigned long pgoff,
                                           unsigned long flags)
{
        if ((flags & MAP_TYPE) == MAP_PRIVATE)
                return -EINVAL;

        if (flags & MAP_FIXED)
                return addr;

        return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
}

BR, Jarkko
