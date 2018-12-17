Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5B1C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 18:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC24E20874
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 18:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeLQSJ6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 13:09:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:39979 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbeLQSJ6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 13:09:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 10:09:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208";a="102212968"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2018 10:09:57 -0800
Date:   Mon, 17 Dec 2018 10:09:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, jethro@fortanix.com
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181217180957.GC12491@linux.intel.com>
References: <20181128192228.GC9023@linux.intel.com>
 <20181210104908.GA23132@wind.enjellic.com>
 <20181212180036.GC6333@linux.intel.com>
 <20181214235917.GA14049@wind.enjellic.com>
 <20181215000627.GA5799@linux.intel.com>
 <20181217132859.GA31936@linux.intel.com>
 <20181217133928.GA32706@linux.intel.com>
 <20181217140811.GA4601@linux.intel.com>
 <20181217173106.GB12491@linux.intel.com>
 <20181217174935.GA12617@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217174935.GA12617@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 07:49:35PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 17, 2018 at 09:31:06AM -0800, Sean Christopherson wrote:
> > This doesn't work as-is.  sgx_encl_release() needs to use sgx_free_page()
> > and not __sgx_free_page() so that we get a WARN() if the page can't be
> > freed.  sgx_invalidate() needs to use __sgx_free_page() as freeing a page
> > can fail due to running concurrently with reclaim.  I'll play around with
> > the code a bit, there's probably a fairly clean way to share code between
> > the two flows.
> 
> Hmm... but why issue a warning in that case? It should be legit
> behaviour.

No, EREMOVE should never fail if the enclave is being released, i.e. all
references to the enclave are gone.  And failure during sgx_encl_release()
means we leaked an EPC page, which warrants a WARN.

The only legitimate reason __sgx_free_page() can fail in sgx_invalidate()
is because a page might be in the process of being reclaimed.  We could
theoretically WARN on EREMOVE failure in that case, but it'd make the code
a little fragile and it's not "fatal" in the sense that we get a second
chance to free the page during sgx_encl_release().

And unless I missed something, using sgx_invalidate() means were' leaking
all sgx_encl_page structs as well as the radix tree entries.
 
> > sgx_encl_release_worker() calls do_unmap() without checking the validity
> > of the page tables[1].  As is, the code doesn't even guarantee mm_struct
> > itself is valid.
> > 
> > The easiest fix I can think of is to add a SGX_ENCL_MM_RELEASED flag
> > that is set along with SGX_ENCL_DEAD in sgx_mmu_notifier_release(), and
> > only call do_unmap() if SGX_ENCL_MM_RELEASED is false.  Note that this
> > means we cant unregister the mmu_notifier until after do_unmap(), but
> > that's true no matter what since we're relying on the mmu_notifier to
> > hold a reference to mm_struct.  Patch attached.
> 
> OK, the fix change makes sense but I'm thinking that would it be a
> better idea just to set mm NULL and check that instead?

That makes sense.
