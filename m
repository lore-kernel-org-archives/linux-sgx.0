Return-Path: <SRS0=PKbn=UR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F14BC31E5B
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 14:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7295C2085A
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 14:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfFROLs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:11:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:49819 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfFROLs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Jun 2019 10:11:48 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 07:11:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="150283558"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 18 Jun 2019 07:11:47 -0700
Date:   Tue, 18 Jun 2019 07:11:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 01/12] x86/sgx: Add mm to enclave at mmap()
Message-ID: <20190618141147.GB13781@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-2-sean.j.christopherson@intel.com>
 <CALCETrXgzzYXrMzcHEYiYE+tvCzU3vFErdzoDEMhMXN_qkQXQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXgzzYXrMzcHEYiYE+tvCzU3vFErdzoDEMhMXN_qkQXQw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 17, 2019 at 04:42:59PM -0700, Andy Lutomirski wrote:
> On Mon, Jun 17, 2019 at 3:24 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > The enclave mm tracking is currently broken:
> >
> >   - Adding current->mm during ECREATE is wrong as there is no guarantee
> >     that the current process has mmap()'d the enclave, i.e. there may
> >     never be an associated sgx_vma_close() to drop the encl_mm.
> >
> >   - Adding mm's at sgx_vma_open() is wrong as vm_ops->open is called
> >     only when splitting or duplicating a vma.  If userspace performs a
> >     single mmap() on the enclave then SGX will fail to track the mm.
> >     This bug is partially hidden by tracking current->mm at ECREATE.
> >
> > Rework the tracking to get/add the mm at mmap().  A side effect of the
> > bug fix is that sgx_vma_{open,close}() should never encounter a vma with
> > an associated enclave and no associated encl_mm, i.e. WARN if an encl_mm
> > cannot be found in either condition.
> >
> 
> It would be nifty if you could also kill .vm_close, since then VMAs
> could be merged properly.  Would this be straightforward?

Hmm, we probably could move the mm tracking to f_op->{open,release}.  The
downside to that approach is that EPC reclaim would unnecessarily walk the
vmas for processes that have opened the enclave but not mapped any EPC
pages.  In the grand scheme, that's a minor issue and probably worth the
tradeoff of vma merging.

On the plus side, in addition to zapping ->close, I think it would allow
for a simpler vma walking scheme.  Maybe.
