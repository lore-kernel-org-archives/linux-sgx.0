Return-Path: <SRS0=squH=AO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACD4C433DF
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 02:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42CEA208FE
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 02:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgGCCiT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jul 2020 22:38:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:3344 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgGCCiQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jul 2020 22:38:16 -0400
IronPort-SDR: riDIuJg/zuRCu7DtUsQqoJxORIY5dFBaRC87FEiNEYJHwKtZsoOzirKusJODJogV+fWSHY5VpH
 yuaSPP33toCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="148600082"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="148600082"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 19:38:15 -0700
IronPort-SDR: eq/Gd5Op0HkHX1MJSxSEhYIo8rjJAtdM032Jr+9u59Wjrns1XLdLqs+40J6K40UDPviXwlt1xw
 GaQKjxl557jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="282151668"
Received: from skochetx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.55.66])
  by orsmga006.jf.intel.com with ESMTP; 02 Jul 2020 19:38:03 -0700
Date:   Fri, 3 Jul 2020 05:38:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
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
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200703023802.GB306897@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
 <20200629160242.GB32176@zn.tnic>
 <20200629220400.GI12312@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629220400.GI12312@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 03:04:00PM -0700, Sean Christopherson wrote:
> On Mon, Jun 29, 2020 at 06:02:42PM +0200, Borislav Petkov wrote:
> > On Thu, Jun 18, 2020 at 01:08:34AM +0300, Jarkko Sakkinen wrote:
> > > Provisioning Certification Enclave (PCE), the root of trust for other
> > > enclaves, generates a signing key from a fused key called Provisioning
> > > Certification Key. PCE can then use this key to certify an attestation key
> > > of a QE, e.g. we get the chain of trust down to the hardware if the Intel
> > 
> > What's a QE?
> > 
> > I don't see this acronym resolved anywhere in the whole patchset.
> 
> Quoting Enclave.
> 
> > > signed PCE is used.
> > > 
> > > To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
> > > only allowed for those who actually need it so that only the trusted
> > > parties can certify QE's.
> > > 
> > > Obviously the attestation service should know the public key of the used
> > > PCE and that way detect illegit attestation, but whitelisting the legit
> > > users still adds an additional layer of defence.
> > > 
> > > Add new device file called /dev/sgx/provision. The sole purpose of this
> > > file is to provide file descriptors that act as privilege tokens to allow
> > > to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
> > > SGX_IOC_ENCLAVE_SET_ATTRIBUTE is used to assign this token to an enclave.
> > 
> > So I'm sure I'm missing something here: what controls which
> > enclave can open /dev/sgx/provision and thus pass the FD to
> > SGX_IOC_ENCLAVE_SET_ATTRIBUTE?
> 
> /dev/sgx/provision is root-only by default, the expectation is that the admin
> will configure the system to grant only specific enclaves access to the
> PROVISION_KEY.
> 
> > And in general, how does that whole flow look like: what calls
> > SGX_IOC_ENCLAVE_SET_ATTRIBUTE when?
> 
> The basic gist is that the host process of an enclave that needs/wants access
> to the PROVISION_KEY will invoke SGX_IOC_ENCLAVE_SET_ATTRIBUTE when building
> the enclave.  Any enclave can request access to PROVISION_KEY, but practically
> speaking only the PCE and QE (or their non-Intel equivalents) actually need
> access to the key.  KVM (future series) will also respect /dev/sgx/provision,
> i.e. require a similar ioctl() to expose the PROVISION_KEY to a guest.
> 
> E.g. for my own personal testing, I never do anything attestation related, so
> none of the enclaves I run request PROVISION_KEY, but I do expose it to VMs to
> test the KVM paths.
> 
> In this series, access is fairly binary, i.e. there's no additional kernel
> infrastructure to help userspace make per-enclave decisions.  There have been
> more than a few proposals on how to extend the kernel to help provide better
> granularity, e.g. LSM hooks, but it was generally agreed to punt that stuff
> to post-upstreaming to keep things "simple" once we went far enough down
> various paths to ensure we weren't painting ourselves into a corner.
> 
> If you want super gory details, Intel's whitepaper on attestation in cloud
> environments is a good starting point[*], but I don't recommended doing much
> more than skimming unless you really like attestation stuff or are
> masochistic, which IMO amount to the same thing :-)
> 
> [*] https://download.01.org/intel-sgx/dcap-1.0/docs/SGX_ECDSA_QuoteGenReference_DCAP_API_Linux_1.0.pdf

Section 3 in [*] is what describes the infrastructure. DCAP is only a
component in the whole attestation infrastructure.

[*] https://software.intel.com/sites/default/files/managed/f1/b8/intel-sgx-support-for-third-party-attestation.pdf

/Jarkko
