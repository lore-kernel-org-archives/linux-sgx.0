Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB47C31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 13:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12224208CB
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 13:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfFSNAX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 09:00:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:37551 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbfFSNAX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 09:00:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 06:00:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="181632245"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jun 2019 06:00:18 -0700
Message-ID: <0542ff39a93a3e696ea73c82110e3e725a079717.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 01/12] x86/sgx: Add mm to enclave at mmap()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Date:   Wed, 19 Jun 2019 16:00:14 +0300
In-Reply-To: <40eea889978d8376ef8afc8a50634d73bcfa79ae.camel@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
         <20190617222438.2080-2-sean.j.christopherson@intel.com>
         <40eea889978d8376ef8afc8a50634d73bcfa79ae.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-06-19 at 15:56 +0300, Jarkko Sakkinen wrote:
> On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
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
> > Change the WARN() on a non-empty mm_list to a WARN_ONCE().  The warning
> > will fire over and over (and over) if the mm tracking is broken, which
> > hampers debug/triage far more than it helps.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 ----------
> >  arch/x86/kernel/cpu/sgx/driver/main.c  | 26 ++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/encl.c         | 38 +++++---------------------
> >  arch/x86/kernel/cpu/sgx/encl.h         |  4 +--
> >  4 files changed, 35 insertions(+), 47 deletions(-)
> 
> BTW, sgx_encl_mm is a bit confusing name (which I made) to begin with. 
> It clues as it was a some kind of 1:1 association with the process,
> which it isn't.
> 
> Could you update the patch and rename it as sgx_encl_mapping? After that
> I'm happy to merge.

And send it as a separate patch. Can merge it today/tomorrow after I've
finished my reaper change.

/Jarkko

