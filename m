Return-Path: <SRS0=HDiP=AK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A6AC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 22:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EFDD206C3
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 22:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgF2WEC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:04:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:13064 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391789AbgF2WEB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 29 Jun 2020 18:04:01 -0400
IronPort-SDR: DHbY/j1+e5YRByWtjoNiEmCgRPpCVnSwSkLrr85eCRZ1qWZRt3T6hfjkORSFy7VK8WoOAtBt+u
 0gpQxvZdnaNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="126217642"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="126217642"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 15:04:00 -0700
IronPort-SDR: SreirR+rW8l5lvYprSMfMupp38yiGawA6y2IndIaYKmlSV9rQeGpcfGD8AVlg9Nf7e28dnSeBc
 NDZmcB9roRzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="454351736"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 29 Jun 2020 15:04:00 -0700
Date:   Mon, 29 Jun 2020 15:04:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
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
Message-ID: <20200629220400.GI12312@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
 <20200629160242.GB32176@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629160242.GB32176@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
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

/dev/sgx/provision is root-only by default, the expectation is that the admin
will configure the system to grant only specific enclaves access to the
PROVISION_KEY.

> And in general, how does that whole flow look like: what calls
> SGX_IOC_ENCLAVE_SET_ATTRIBUTE when?

The basic gist is that the host process of an enclave that needs/wants access
to the PROVISION_KEY will invoke SGX_IOC_ENCLAVE_SET_ATTRIBUTE when building
the enclave.  Any enclave can request access to PROVISION_KEY, but practically
speaking only the PCE and QE (or their non-Intel equivalents) actually need
access to the key.  KVM (future series) will also respect /dev/sgx/provision,
i.e. require a similar ioctl() to expose the PROVISION_KEY to a guest.

E.g. for my own personal testing, I never do anything attestation related, so
none of the enclaves I run request PROVISION_KEY, but I do expose it to VMs to
test the KVM paths.

In this series, access is fairly binary, i.e. there's no additional kernel
infrastructure to help userspace make per-enclave decisions.  There have been
more than a few proposals on how to extend the kernel to help provide better
granularity, e.g. LSM hooks, but it was generally agreed to punt that stuff
to post-upstreaming to keep things "simple" once we went far enough down
various paths to ensure we weren't painting ourselves into a corner.

If you want super gory details, Intel's whitepaper on attestation in cloud
environments is a good starting point[*], but I don't recommended doing much
more than skimming unless you really like attestation stuff or are
masochistic, which IMO amount to the same thing :-)

[*] https://download.01.org/intel-sgx/dcap-1.0/docs/SGX_ECDSA_QuoteGenReference_DCAP_API_Linux_1.0.pdf
