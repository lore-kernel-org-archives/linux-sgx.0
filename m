Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03549C636D7
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Feb 2023 22:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBQWcU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Feb 2023 17:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjBQWcT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Feb 2023 17:32:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61725FBEC
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 14:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D396207E
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 22:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BDCC433D2;
        Fri, 17 Feb 2023 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676673137;
        bh=PIlOM6MwTrk30J+2BdnlwaOi4z6TTn8DDgVBI+zLpMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rr0gROZYwC71tTHbaOqjWK/A8gNy3iDdI1k7wWSjPhufAg5tIrbGnvW7N5vCq+kqC
         eXWFgo3JYKp2BF+dnHpot4hetPBmlpsWKY2AMbELg5n973AUapmACEqGtC+wktYr0M
         omwS3ZoifhEFhwj6KtktAlcyA1hXxKreR4wao4R12C3Pq+HVFtMnVn3XAkn4TbD1kM
         4pjNmfIdBwjF8BactVCEyHAwxPVYA1kPQ//aw6wtROsHrf4vHadf24MqSJIPYZIMmh
         oXUS3Hu/glbWeP1Z9y3V9/IGgBi6lHCmokufrhapf3GRuUjpr7ZFeuZKy1UfYi5/OS
         nJ0dz6ZBXzokw==
Date:   Sat, 18 Feb 2023 00:32:12 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y/AAbC/j04aUkd8R@kernel.org>
References: <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 15, 2023 at 09:42:30AM -0600, Haitao Huang wrote:
> On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai <kai.huang@intel.com> wrote:
> 
> > > > > >
> > > >
> > > > Since sgx_mmap() can happen before enclave is created, calculating the
> > > > vm_pgoff
> > > > from enclave_base is conceptually wrong.  Even if you really want
> > > to do
> > > > it, it
> > > > should be:
> > > >
> > > > 	if (enclave_has_initialized())
> > > > 		vma->vm_pgoff = ...;
> > > 
> > > I got your point now. I can add a condition to test the SGX_ENCL_CREATED
> > > bit. However, we still have a hole if we must handle the sequence
> > > mmap(..., enclave_fd) being called before ECREATE ioctl. We can't leave
> > > vm_pgoff not set for those cases.
> > > 
> > > Since no one does that so far, can we explicitly return an error from
> > > sgx_mmap when that happens?
> > > Other suggestions?
> > 
> > As I replied to patch 4/4, I believe userspace should pass the correct
> > pgoff in
> > mmap().  It's wrong to always pass 0 or any random value.
> > 
> > If userspace follow the mmap() rule, you won't need to manually set
> > vm_pgoff
> > here (which is hacky IMHO).  Everything works fine.
> > 
> 
> SGX driver was following MAP_ANONYMOUS semantics. If we change that, it'd
> break current usage/ABI.
> 
> I still think returning error for cases mmap(..., enclave_fd) if enclave is
> not created would be less intrusive change.

Is this something you care in SGX SDK?

It is not categorically forbidden so that's why I'm asking.

BR, Jarkko
