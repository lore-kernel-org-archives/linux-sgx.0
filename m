Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B259CC636D7
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Feb 2023 22:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBUWKK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Feb 2023 17:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBUWKJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 21 Feb 2023 17:10:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C7E28D2A
        for <linux-sgx@vger.kernel.org>; Tue, 21 Feb 2023 14:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D525CE1C00
        for <linux-sgx@vger.kernel.org>; Tue, 21 Feb 2023 22:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AE6C433D2;
        Tue, 21 Feb 2023 22:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677017404;
        bh=/KOCKIzArn4p8xkCuBcWxJ7sFTzTC4AsKqx15mN5VYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YQmf3M8BDp3fX1/UqloYpsa9gukMSiaxlLXABLYsm8/KcfZQ7J21iXyM9CUb4blyj
         18IDFbHxmDVCD1OIOA2jgo5yuW++dRVf3TmpytWwlgerlYeT5745P/el8TUEmyQYP2
         38+q///IueVt7Nur4gYDFcSx6JhARJ0spGypovIwVhqWdJEaxIZdCg3iIq4eK4NQ3D
         GJ/nhQGiACbE5jcFv0tTdfLA1fnFeB2ZY6I9EKzxET7abvG/G8XR84ZUsPDh6sa3+k
         C/8x3XHDER5fjyjGoYmgyRMI1JjPVsCPhGGY+7LzVFdHFYUXkeWl9NZPRrnsFCtQZF
         g5St3Q3/S+iNg==
Date:   Wed, 22 Feb 2023 00:10:02 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y/VBOkmi7VbVuzAh@kernel.org>
References: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/AAbC/j04aUkd8R@kernel.org>
 <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 17, 2023 at 05:03:05PM -0600, Haitao Huang wrote:
> Hi Jarkko
> 
> On Fri, 17 Feb 2023 16:32:12 -0600, jarkko@kernel.org <jarkko@kernel.org>
> wrote:
> 
> > On Wed, Feb 15, 2023 at 09:42:30AM -0600, Haitao Huang wrote:
> > > On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai <kai.huang@intel.com>
> > > wrote:
> > > 
> > > > > > > >
> > > > > >
> > > > > > Since sgx_mmap() can happen before enclave is created,
> > > calculating the
> > > > > > vm_pgoff
> > > > > > from enclave_base is conceptually wrong.  Even if you really want
> > > > > to do
> > > > > > it, it
> > > > > > should be:
> > > > > >
> > > > > > 	if (enclave_has_initialized())
> > > > > > 		vma->vm_pgoff = ...;
> > > > >
> > > > > I got your point now. I can add a condition to test the
> > > SGX_ENCL_CREATED
> > > > > bit. However, we still have a hole if we must handle the sequence
> > > > > mmap(..., enclave_fd) being called before ECREATE ioctl. We
> > > can't leave
> > > > > vm_pgoff not set for those cases.
> > > > >
> > > > > Since no one does that so far, can we explicitly return an error
> > > from
> > > > > sgx_mmap when that happens?
> > > > > Other suggestions?
> > > >
> > > > As I replied to patch 4/4, I believe userspace should pass the correct
> > > > pgoff in
> > > > mmap().  It's wrong to always pass 0 or any random value.
> > > >
> > > > If userspace follow the mmap() rule, you won't need to manually set
> > > > vm_pgoff
> > > > here (which is hacky IMHO).  Everything works fine.
> > > >
> > > 
> > > SGX driver was following MAP_ANONYMOUS semantics. If we change that,
> > > it'd
> > > break current usage/ABI.
> > > 
> > > I still think returning error for cases mmap(..., enclave_fd) if
> > > enclave is
> > > not created would be less intrusive change.
> > 
> > Is this something you care in SGX SDK?
> > 
> > It is not categorically forbidden so that's why I'm asking.
> 
> SDK does not care as we would never do this and don't think anyone is doing
> that either. Suggesting returning error to cover all cases so user space
> would not accidentally cause incorrect vm_pgoff set.

vm_pgoff != 0 should result -EINVAL.

BR, Jarkko
