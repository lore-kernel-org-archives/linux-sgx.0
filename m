Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FF0C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 20:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 318A62083B
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 20:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfFTUJK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 16:09:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:62494 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfFTUJJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 16:09:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 13:09:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="168622209"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2019 13:09:06 -0700
Date:   Thu, 20 Jun 2019 23:09:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 01/12] x86/sgx: Add mm to enclave at mmap()
Message-ID: <20190620200846.GE15383@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-2-sean.j.christopherson@intel.com>
 <40eea889978d8376ef8afc8a50634d73bcfa79ae.camel@linux.intel.com>
 <0542ff39a93a3e696ea73c82110e3e725a079717.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0542ff39a93a3e696ea73c82110e3e725a079717.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 04:00:14PM +0300, Jarkko Sakkinen wrote:
> On Wed, 2019-06-19 at 15:56 +0300, Jarkko Sakkinen wrote:
> > On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> > > The enclave mm tracking is currently broken:
> > > 
> > >   - Adding current->mm during ECREATE is wrong as there is no guarantee
> > >     that the current process has mmap()'d the enclave, i.e. there may
> > >     never be an associated sgx_vma_close() to drop the encl_mm.
> > > 
> > >   - Adding mm's at sgx_vma_open() is wrong as vm_ops->open is called
> > >     only when splitting or duplicating a vma.  If userspace performs a
> > >     single mmap() on the enclave then SGX will fail to track the mm.
> > >     This bug is partially hidden by tracking current->mm at ECREATE.
> > > 
> > > Rework the tracking to get/add the mm at mmap().  A side effect of the
> > > bug fix is that sgx_vma_{open,close}() should never encounter a vma with
> > > an associated enclave and no associated encl_mm, i.e. WARN if an encl_mm
> > > cannot be found in either condition.
> > > 
> > > Change the WARN() on a non-empty mm_list to a WARN_ONCE().  The warning
> > > will fire over and over (and over) if the mm tracking is broken, which
> > > hampers debug/triage far more than it helps.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 ----------
> > >  arch/x86/kernel/cpu/sgx/driver/main.c  | 26 ++++++++++++++++++
> > >  arch/x86/kernel/cpu/sgx/encl.c         | 38 +++++---------------------
> > >  arch/x86/kernel/cpu/sgx/encl.h         |  4 +--
> > >  4 files changed, 35 insertions(+), 47 deletions(-)
> > 
> > BTW, sgx_encl_mm is a bit confusing name (which I made) to begin with. 
> > It clues as it was a some kind of 1:1 association with the process,
> > which it isn't.
> > 
> > Could you update the patch and rename it as sgx_encl_mapping? After that
> > I'm happy to merge.
> 
> And send it as a separate patch. Can merge it today/tomorrow after I've
> finished my reaper change.

Still working/testing reaper stuff but this one is now applied. Lets
not do any renames for the moment because they only slow down. That
was a bad suggestion from my part.

The reason I squashed this change is that it is a pure bug fix.

If there is a bug, lets try to just fix that with absolutely minimal
intrusion. Only after that consider a "better way".

/Jarkko
