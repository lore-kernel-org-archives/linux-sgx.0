Return-Path: <SRS0=Ho1r=UZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF35C48BD3
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jun 2019 12:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6EF12147A
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jun 2019 12:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfFZMur (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jun 2019 08:50:47 -0400
Received: from wind.enjellic.com ([76.10.64.91]:36394 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZMur (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Jun 2019 08:50:47 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5QCnw2O020449;
        Wed, 26 Jun 2019 07:49:58 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5QCnvFQ020448;
        Wed, 26 Jun 2019 07:49:57 -0500
Date:   Wed, 26 Jun 2019 07:49:57 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to map enclave page WX
Message-ID: <20190626124957.GA20130@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com> <20190619222401.14942-9-sean.j.christopherson@intel.com> <119f6de8-e7b6-6ebd-be12-862303806ea7@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <119f6de8-e7b6-6ebd-be12-862303806ea7@tycho.nsa.gov>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 26 Jun 2019 07:49:58 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 25, 2019 at 04:19:35PM -0400, Stephen Smalley wrote:

Good morning, I hope the week is going well for everyone.

> On 6/19/19 6:23 PM, Sean Christopherson wrote:
> >Hook enclave_map() to require a new per-process capability, SGX_MAPWX,
> >when mapping an enclave as simultaneously writable and executable.
> >Note, @prot contains the actual protection bits that will be set by the
> >kernel, not the maximal protection bits specified by userspace when the
> >page was first loaded into the enclave.
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  security/selinux/hooks.c            | 21 +++++++++++++++++++++
> >  security/selinux/include/classmap.h |  3 ++-
> >  2 files changed, 23 insertions(+), 1 deletion(-)
> >
> >diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >index 3ec702cf46ca..fc239e541b62 100644
> >--- a/security/selinux/hooks.c
> >+++ b/security/selinux/hooks.c
> >@@ -6726,6 +6726,23 @@ static void selinux_bpf_prog_free(struct 
> >bpf_prog_aux *aux)
> >  }
> >  #endif
> >  
> >+#ifdef CONFIG_INTEL_SGX
> >+static int selinux_enclave_map(unsigned long prot)
> >+{
> >+	const struct cred *cred = current_cred();
> >+	u32 sid = cred_sid(cred);
> >+
> >+	/* SGX is supported only in 64-bit kernels. */
> >+	WARN_ON_ONCE(!default_noexec);
> >+
> >+	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> >+		return avc_has_perm(&selinux_state, sid, sid,
> >+				    SECCLASS_PROCESS2, PROCESS2__SGX_MAPWX,
> >+				    NULL);

> Possibly we should use a slightly more general name for the
> permission to allow reusing it in the future if/when another
> architecture introduces a similar construct under a different
> branding?  ENCLAVE_* seems slightly more generic than SGX_*.

Perhaps TEE_*, since it is generic and expresses the notion of
privileges specific to an alternate execution environment.

> I was interested in testing this code but sadly the driver reports
> the following on my development workstation:
>
> [    1.644191] sgx: The launch control MSRs are not writable
> [    1.695477] sgx: EPC section 0x70200000-0x75f7ffff
> [    1.771760] sgx: The public key MSRs are not writable
>
> I guess I'm out of luck until/unless I get a NUC or server class
> hardware that supports flexible launch control?  Seems developer
> unfriendly.

Indeed.

Most importantly, it is decidedly unfriendly to the future of the
technology on Linux.

More problematically, from a development perspective, the driver is
incompatible with the current Intel runtime, which makes testing at a
level beyond the one page test harness that is included with the
patchset impossible.

As I noted previously, before the LSM discussion, we have a patch that
addresses the compatibility, security and launch control issues the
original version of the driver had.  If you missed the thread, it is
available from the following URL:

ftp://ftp.idfusion.net/pub/idfusion/jarkko-master-SFLC.patch

It will be a bit dated by now and doesn't address the API change
needed to set page permissions.  It is a pretty solid starting point
if you want to use the existing runtime to do more then trivial
testing.

We have an extension to the existing driver that we will be releasing,
so users of our SRDE will be able to use both the out-of-tree and
in-tree drivers.  It also re-establishes launch control and provides a
very simplistic interface to implement ring-0 security for launch
control on flexible launch control platforms.

I'm in Israel right now but we should have a GIT tree against the
current development branches by the weekend.  We will be testing the
driver with our SRDE against real world enclaves as we advance the
driver forward.

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC
4206 N. 19th Ave.           Implementing measured information privacy
Fargo, ND  58102            and integrity architectures.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"This place is so screwed up.  It's just like the Titanic, only
 we don't even have a band playing.
                                -- Terrance George Wieland
                                   Resurrection.
