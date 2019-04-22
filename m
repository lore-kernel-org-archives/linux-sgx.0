Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F6FC282CE
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD1B214AE
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfDVQsg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:48:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:62086 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbfDVQsa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 12:48:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 09:48:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,382,1549958400"; 
   d="scan'208";a="339732309"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga005.fm.intel.com with ESMTP; 22 Apr 2019 09:48:28 -0700
Date:   Mon, 22 Apr 2019 09:48:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190422164827.GC1236@linux.intel.com>
References: <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
 <20190420160247.GA17291@wind.enjellic.com>
 <20190422150119.GA1236@linux.intel.com>
 <20190422162411.GA27389@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422162411.GA27389@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 11:24:11AM -0500, Dr. Greg wrote:
> On Mon, Apr 22, 2019 at 08:01:19AM -0700, Sean Christopherson wrote:
> 
> Good morning to everyone, I hope the week is starting well.
> 
> > On Sat, Apr 20, 2019 at 11:02:47AM -0500, Dr. Greg wrote:
> > > We understand and support the need for the LSM to trap these
> > > events, but what does LSM provenance mean if the platform is
> > > compromised?  That is, technically, the target application for SGX
> > > technology.
> 
> > No, it's not.  Protecting the kernel/platform from a malicious
> > entity is outside the scope of SGX.
> 
> You must have misinterpreted my statement, providing security
> guarantees in the face of a compromised platform is exactly what SGX
> was designed to do and is how Intel is marketing the technology.

Right, and loading a malicious enclave doesn't change those guarantees
(for other enclaves).  Ergo, restricting which enclaves can execute is
orthogonal to the security provided by SGX.
