Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4A2C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 18:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B07A20874
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 18:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbeLQSq0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 13:46:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:20171 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbeLQSqZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 13:46:25 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 10:46:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208";a="99422877"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga007.jf.intel.com with ESMTP; 17 Dec 2018 10:46:25 -0800
Date:   Mon, 17 Dec 2018 10:46:25 -0800
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
Message-ID: <20181217184625.GE12491@linux.intel.com>
References: <20181212180036.GC6333@linux.intel.com>
 <20181214235917.GA14049@wind.enjellic.com>
 <20181215000627.GA5799@linux.intel.com>
 <20181217132859.GA31936@linux.intel.com>
 <20181217133928.GA32706@linux.intel.com>
 <20181217140811.GA4601@linux.intel.com>
 <20181217173106.GB12491@linux.intel.com>
 <20181217174935.GA12617@linux.intel.com>
 <20181217180957.GC12491@linux.intel.com>
 <20181217182319.GA13288@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217182319.GA13288@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 08:23:19PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 17, 2018 at 10:09:57AM -0800, Sean Christopherson wrote:
> > No, EREMOVE should never fail if the enclave is being released, i.e. all
> > references to the enclave are gone.  And failure during sgx_encl_release()
> > means we leaked an EPC page, which warrants a WARN.
> 
> Right that what I was suspecting as swapper should hold a ref to the
> enclave while it is working on it. It is a programming error when this
> happens.
> 
> Maybe change the boolean parameter to flags parameter have a flag to
> use sgx_free_page()?

I tried that approach when I first split it to __sgx_free_page() and
sgx_free_page(), but IMO the code is more difficult to read and harder
to maintain since sgx_free_page() should be used except under special
circumstances, e.g. race with reclaim or the freeing is "untrusted",
i.e. requested by userspace via sgx_ioc_enclave_remove_pages().

> 
> > That makes sense.
> 
> What do you think of Dave's proposal?
> 
> /Jarkko
