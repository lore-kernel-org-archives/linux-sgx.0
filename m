Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD11C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 15:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1377221852
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 15:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeLRPqd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:46:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:1274 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbeLRPqc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 10:46:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 07:46:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,368,1539673200"; 
   d="scan'208";a="119413497"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Dec 2018 07:46:31 -0800
Date:   Tue, 18 Dec 2018 07:46:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-sgx@vger.kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181218154631.GD28326@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <20181217184858.GF12491@linux.intel.com>
 <20181217193322.GA29785@linux.intel.com>
 <20181217202149.GA19053@linux.intel.com>
 <20181218131311.GB25667@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218131311.GB25667@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 18, 2018 at 03:13:11PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 17, 2018 at 10:21:49PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 17, 2018 at 09:33:22PM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Dec 17, 2018 at 10:48:58AM -0800, Sean Christopherson wrote:
> > > > On Mon, Dec 17, 2018 at 08:43:33PM +0200, Jarkko Sakkinen wrote:
> > > > > On Mon, Dec 17, 2018 at 10:36:13AM -0800, Sean Christopherson wrote:
> > > > > > I'm pretty sure doing mmget() would result in circular dependencies and
> > > > > > a zombie enclave.  In the do_exit() case where a task is abruptly killed:
> > > > > >  
> > > > > >   - __mmput() is never called because the enclave holds a ref
> > > > > >   - sgx_encl_release() is never be called because its VMAs hold refs
> > > > > >   - sgx_vma_close() is never called because __mmput()->exit_mmap() is
> > > > > >     blocked and the process itself is dead, i.e. won't unmap anything.
> > > > > 
> > > > > Right, it does, you are absolutely right. Tried it and removed the
> > > > > commit already.
> > > > > 
> > > > > Well, what we came up from your suggestion i.e. setting mm to NULL
> > > > > and checking that is very subtle change and does not have any such
> > > > > circular dependencies. We'll go with that.
> > > > 
> > > > We can't set mm to NULL as we need it to unregister the notifier, and
> > > > I'm fairly certain attempting to unregister in the release callback
> > > > will deadlock.
> > > 
> > > Noticed that too. mmu_notifier_unregister() requires a valid mm.
> > 
> > Both branches updated...
> 
> I'm not still seeing why you would want to call sgx_free_page() from
> sgx_invalidate(). Kind of resistant to adding extra logging just for
> checking for programming errors. What I would do if I had to debug
> there a leak would be simply put kretprobe on __sgx_free_page().

The WARN is needed to detect the leak in the first place.  And leaking
pages because EREMOVE fails usually means there's a serious bug.
