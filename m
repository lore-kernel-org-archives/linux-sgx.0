Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4145C35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 23:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90D2F217F4
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 23:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgBEXIC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:08:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:62071 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBEXIC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Feb 2020 18:08:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 15:08:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225098507"
Received: from gtobin-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.85])
  by fmsmga007.fm.intel.com with ESMTP; 05 Feb 2020 15:07:56 -0800
Date:   Thu, 6 Feb 2020 01:07:56 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v25 21/21] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200205230756.GB28111@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-22-jarkko.sakkinen@linux.intel.com>
 <5ea28632-cd64-bc26-fab6-2868142eb9e4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ea28632-cd64-bc26-fab6-2868142eb9e4@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 05, 2020 at 09:54:31AM -0800, Randy Dunlap wrote:
> Hi,
> I have some Documentation edits. Please see inline below...
>
> or just: ``grep sgx /proc/cpuinfo

Makes sense.

> > +key set into MSRs, which would then generate launch tokens for other enclaves.
> > +This would only make sense with read-only MSRs, and thus the option has been
> > +discluded.
> 
> I can't find "discluded" in a dictionary.

Should be "discarded".

> "MAC" can mean a lots of different things.  Which one is this?

Message authentication code. I open

I rewrote the whole local attestation section:

"In local attestation an enclave creates a **REPORT** data structure
with **ENCLS[EREPORT]**, which describes the origin of an enclave. In
particular, it contains a AES-CMAC of the enclave contents signed with a
report key unique to each processor. All enclaves have access to this
key.

This mechanism can also be used in addition as a communication channel
as the **REPORT** data structure includes a 64-byte field for variable
information."

> > +* ECDSA based scheme, which 3rd party to act as an attestation service.
> 
>                          which uses a 3rd party
> or
>                          using a 3rd party

It should be "allows a 3rd party".

> > +Intel provides an open source *quoting enclave (QE)* and *provisioning
> > +certification enclave (PCE)* for the ECDSA based scheme. The latter acts as
> > +the CA for the local QE's. Intel also a precompiled binary version of the PCE
> 
>                                     also provides [??]

I rewrote it as:

"Intel provides a proprietary binary version of the PCE. This is a
necessity when the software needs to prove to be running inside a legit
enclave on real hardware."

Thank you for the comments.

/Jarkko
