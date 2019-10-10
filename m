Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4EBC10F14
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 17:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B626920659
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 17:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfJJRjn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:39:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:28183 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfJJRjn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 13:39:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 10:39:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="369164380"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 10 Oct 2019 10:39:42 -0700
Date:   Thu, 10 Oct 2019 10:39:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20191010173942.GC23798@linux.intel.com>
References: <20191010113745.GA12842@linux.intel.com>
 <20191010132458.GA4112@linux.intel.com>
 <20191010170921.GB23798@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010170921.GB23798@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 10:09:21AM -0700, Sean Christopherson wrote:
> On Thu, Oct 10, 2019 at 04:37:53PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 10, 2019 at 02:37:45PM +0300, Jarkko Sakkinen wrote:
> > > tag v23-rc2
> > > Tagger: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Date:   Thu Oct 10 14:33:07 2019 +0300
> > > 
> > > x86/sgx: v23-rc1 patch set
> > > 
> > > * Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS page.
> > > * In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can fail
> > >   (because of OOM) even in legit behaviour and after EBLOCK the reclaiming
> > >   flow can be only reverted by killing the whole enclave.
> > > * Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in fact
> > >   it should have been bit 6 (Table 37-3 in the SDM).
> > > * Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an SGX
> > >   error code.
> > > * In v22 __uaccess_begin() was used to pin the source page in
> > >   __sgx_encl_add_page(). Switch to get_user_pages() in order to avoid
> > >   deadlock (mmap_sem might get locked twice in the same thread).
> > 
> > __uaccess_begin() is also needed to performan access checks the legit
> 
> __uaccess_begin() doesn't check the address space, it temporarily disables
> SMAP/SMEP so that the kernel can access a user mapping.  An explicit
> access_ok() call should be added as well.
> 
> > user space address. What we can do is to use get_user_pages() just to
> > make sure that the page is faulted while we perform ENCLS[EADD].
> 
> 
> > I updated the master branch with the fix for this. Now the access
> > pattern is:
> > 
> > 	ret = get_user_pages(src, 1, 0, &src_page, NULL);
> > 	if (ret < 1)
> > 		return ret;
> > 
> > 	__uaccess_begin();
> 
> This should be immediately before __eadd().  I also think it'd be a good
> idea to disable page faults around __eadd() so that an unexpected #PF
> manifests as an __eadd() failure and not a kernel hang.

Scratch that, using the userspace is address is flat out wrong.  gup()
doesn't guarantee the userspace mapping is valid, i.e. EADD can still get
a #PF and deadlock.  AIUI, the correct/bulletproof approach is to kmap()
after gup() and use the kernel translation.
