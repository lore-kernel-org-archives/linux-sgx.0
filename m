Return-Path: <SRS0=squH=AO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2547C433DF
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 02:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE2920781
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 02:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGCCc3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jul 2020 22:32:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:24277 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGCCc2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jul 2020 22:32:28 -0400
IronPort-SDR: YA7Xnsze6pmgAkxD8RK3+hjz/2ED5jehk5TuOwIZw/2BR5uiWGyuLuh+yCnoAjUTUsfoU3gGNF
 F11/4KeSPUnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="126682907"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="126682907"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 19:32:28 -0700
IronPort-SDR: nNQGXlodZBsiyF7oNmMJC04fBdPJEqP6YcTfyXBJqnlbD2TiZfMJqMh12whCQxg4wZhnlMP8ud
 KxH23C3FwspA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="278294996"
Received: from skochetx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.55.66])
  by orsmga003.jf.intel.com with ESMTP; 02 Jul 2020 19:32:17 -0700
Date:   Fri, 3 Jul 2020 05:32:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200703023146.GA306897@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
 <20200629160242.GB32176@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629160242.GB32176@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 06:02:42PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:34AM +0300, Jarkko Sakkinen wrote:
> > Provisioning Certification Enclave (PCE), the root of trust for other
> > enclaves, generates a signing key from a fused key called Provisioning
> > Certification Key. PCE can then use this key to certify an attestation key
> > of a QE, e.g. we get the chain of trust down to the hardware if the Intel
> 
> What's a QE?
> 
> I don't see this acronym resolved anywhere in the whole patchset.

Quoting Enclave.

> 
> > signed PCE is used.
> > 
> > To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
> > only allowed for those who actually need it so that only the trusted
> > parties can certify QE's.
> > 
> > Obviously the attestation service should know the public key of the used
> > PCE and that way detect illegit attestation, but whitelisting the legit
> > users still adds an additional layer of defence.
> > 
> > Add new device file called /dev/sgx/provision. The sole purpose of this
> > file is to provide file descriptors that act as privilege tokens to allow
> > to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
> > SGX_IOC_ENCLAVE_SET_ATTRIBUTE is used to assign this token to an enclave.
> 
> So I'm sure I'm missing something here: what controls which
> enclave can open /dev/sgx/provision and thus pass the FD to
> SGX_IOC_ENCLAVE_SET_ATTRIBUTE?
> 
> And in general, how does that whole flow look like: what calls
> SGX_IOC_ENCLAVE_SET_ATTRIBUTE when?

I've documented it in the Remote Attestation section:

https://github.com/jsakkine-intel/linux-sgx/blob/master/Documentation/x86/sgx.rst

/Jarkko
