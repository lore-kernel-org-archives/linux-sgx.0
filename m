Return-Path: <SRS0=mkZ9=OE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9C7C43441
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 14:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0861A2086B
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 14:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0861A2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbeKZBoz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 25 Nov 2018 20:44:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:20124 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbeKZBoz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 25 Nov 2018 20:44:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2018 06:53:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,278,1539673200"; 
   d="scan'208";a="109097807"
Received: from djustese-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.168])
  by fmsmga004.fm.intel.com with ESMTP; 25 Nov 2018 06:53:30 -0800
Date:   Sun, 25 Nov 2018 06:53:29 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Dr. Greg Wettstein" <greg@enjellic.com>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181125145329.GA5777@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com>
 <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com>
 <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124172114.GB32210@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 24, 2018 at 09:21:14AM -0800, Jarkko Sakkinen wrote:
> On Thu, Nov 22, 2018 at 07:21:08AM -0800, Andy Lutomirski wrote:
> > > At a high level, addressing these issues is straight forward.  First,
> > > the driver needs to support authorization equivalent to that which is
> > > implemented in the current Intel Launch Enclave, ie. control over the
> > > SGX_FLAGS_PROVISION_KEY attribute.
> > 
> > I agree, hence my email :)
> 
> Started to scratch my head that is it really an issue that any enclave
> can provision in the end?
> 
> Direct quote from your first response:
> 
> "In particular, the ability to run enclaves with the provisioning bit set
> is somewhat sensitive, since it effectively allows access to a stable
> fingerprint of the system."
> 
> As can be seen from the key derivation table this does not exactly hold
> so you should refine your original argument before we can consider any
> type of change.
> 
> I just don't see what it is so wrong for any enclave to be able to tell
> that it really is an enclave.

I mean I can understand why Greg wants LE although I don't understand
what benefit does it bring to anyone to lock in for enclave to allow
to identify itself.

What you are proposing does not really bring any additional security if
we consider a threat model where the kernel is an adversary but it makes
the software stack more clanky to use.

/Jarkko
