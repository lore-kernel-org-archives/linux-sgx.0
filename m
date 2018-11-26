Return-Path: <SRS0=Z3oH=OF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23B2C43441
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 19:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DD0B20817
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 19:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DD0B20817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbeK0GeP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Nov 2018 01:34:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:21757 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbeK0GeP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Nov 2018 01:34:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2018 11:39:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,283,1539673200"; 
   d="scan'208";a="109013289"
Received: from jsakkine-mobl1.jf.intel.com (HELO localhost) ([10.24.8.61])
  by fmsmga002.fm.intel.com with ESMTP; 26 Nov 2018 11:39:05 -0800
Date:   Mon, 26 Nov 2018 11:39:06 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
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
        Darren Hart <dvhart@infradead.org>, andy@infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181126193906.GA32327@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181120111508.GA26127@wind.enjellic.com>
 <20181124161521.GB30310@linux.intel.com>
 <20181124192454.GA12149@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124192454.GA12149@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 24, 2018 at 01:24:54PM -0600, Dr. Greg wrote:
> On Sat, Nov 24, 2018 at 08:15:21AM -0800, Jarkko Sakkinen wrote:
> 
> > On Tue, Nov 20, 2018 at 05:15:08AM -0600, Dr. Greg wrote:
> > > Malware would not necessarily need the Intel attestation service.
> > > Once access to the PROVISION bit is available, malware teams could
> > > simply build their own attestation service.
> 
> > AFAIK not possible as they wouldn't have access to the root
> > provisioning key. Can be confirmed from the SDM's key derivation
> > table (41-56).
> 
> What provisioning and attestation is all about is establishing an
> identity binding for a platform in question.  The standard Intel
> service binds the identity of a platform to an EPID private key.
> 
> With access to the SGX_FLAGS_PROVISION_BIT an enclave can generate a
> perpetual identity for a platform based on the identity modulus
> signature (MRSIGNER) of the key that signs the signature structure of
> the enclave.  Without access to the root provisioning key a security
> quorum or group has to be implemented via a subscription or enrollment
> model but that is arguably not much of an obstacle.
> 
> That is pretty much the way standard botware works now.
> 
> Without provisions for cryptographically secure authorization and
> policy enforcement in the driver, we will be creating infrastructure
> for a new generation of botware/malware whose mothership will know
> that a participating platform is running with full confidentiality and
> integrity protections.

OK, I think I got what you mean.

With free access to the provision the bot net controller could be sure
that a node is running inside an enclave. Is this what you are worried
about? Please correct if not or even if there is a slight drift on what
you are trying to state.

/Jarkko
