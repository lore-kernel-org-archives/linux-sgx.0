Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5096DC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 13:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366C620786
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 13:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHRNay (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:30:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:30975 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgHRNaq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 09:30:46 -0400
IronPort-SDR: jNdtA3Y7TU7DSpeWm+hkBTwXujSn1HEyRfk+htIHdLshtAHxL8FfuYEqHF4ATvazDEXbR+iORW
 OSvMhmMhTEHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134417565"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="134417565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 06:30:44 -0700
IronPort-SDR: jXUvZvRc+cIhhVBV2rYBhufEk84sPAFYVdOiBEwrwpRlcSSFTst3dT741J0f+18reKSDfNcmNW
 VtGIKQJbXNxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="292764503"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2020 06:30:36 -0700
Date:   Tue, 18 Aug 2020 16:30:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Darren Kenny <darren.kenny@oracle.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v36 15/24] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200818133026.GA132200@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-16-jarkko.sakkinen@linux.intel.com>
 <m27dubr9pp.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m27dubr9pp.fsf@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 06, 2020 at 06:00:02PM +0100, Darren Kenny wrote:
> On Thursday, 2020-07-16 at 16:52:54 +03, Jarkko Sakkinen wrote:
> > Provisioning Certification Enclave (PCE), the root of trust for other
> > enclaves, generates a signing key from a fused key called Provisioning
> > Certification Key. PCE can then use this key to certify an attestation key
> > of a Quoting Enclave (QE), e.g. we get the chain of trust down to the
> > hardware if the Intel signed PCE is used.
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
> >
> > Cc: linux-security-module@vger.kernel.org
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

Thanks, I added your tags to the corresponding commits.

/Jarkko
