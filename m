Return-Path: <SRS0=zo89=OB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245FDC43441
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Nov 2018 11:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC98E20663
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Nov 2018 11:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC98E20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbeKVVwg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Nov 2018 16:52:36 -0500
Received: from wind.enjellic.com ([76.10.64.91]:58450 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732060AbeKVVwg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Nov 2018 16:52:36 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.14.3/8.14.3) with ESMTP id wAMBCrYk032663;
        Thu, 22 Nov 2018 05:12:53 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.14.3/8.14.3/Submit) id wAMBCrso032662;
        Thu, 22 Nov 2018 05:12:53 -0600
Date:   Thu, 22 Nov 2018 05:12:53 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20181122111253.GA31150@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120120442.GA22172@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [0.0.0.0]); Thu, 22 Nov 2018 05:12:53 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 20, 2018 at 02:04:42PM +0200, Jarkko Sakkinen wrote:

Good morning to everyone, Happy Thanksgiving to those who are
celebrating the holiday.

> On Mon, Nov 19, 2018 at 08:59:24AM -0800, Andy Lutomirski wrote:
> > The idea here is that, under normal circumstances, provisioning only
> > runs once, or at least only runs rarely.  So, rather than the SDK
> > running provisioning whenever it feels like doing so (which is the
> > current behavior, I imagine, although I haven't looked), there would
> > be a privileged program, perhaps a systemd unit that runs when needed,
> > that produces the key material needed for remote attestation, and
> > non-root users that need attestation would get the keying material
> > from the provisioning service.  And the provisioning service could
> > implement its own policy.  Ideally, the service wouldn't give the
> > sealed keys to users at all but would, instead, just provide the
> > entire attestation service over a UNIX socket, which would make
> > provisioning capabilities revocable.
> > 
> > Does this make sense?

> Yes, it does for me at least now that you brought some context.

Let me see if I can add a bit of additional context to the above to
frame further discussion regarding two major needs of the driver
before it lands.

What Andy is describing is how the current system already works.  The
driver is at the root of a fairly complex eco-system of code,
cryptography and protocols that implement SGX functionality.  This
software stack is known as the SGX Platform SoftWare (PSW) or SGX
runtime.

The Intel provided runtime is implemented in C++ and, depending on how
you count it, clocks in at around 50+ KLOC.  All of this ends up as a
single 1.8 megabyte binary named aesm_service that links against 35
shared libraries and is run by systemd.

This binary implements the functionality needed to load, initialize,
run and attest enclaves.  It also implements communications with the
Intel provisioning and attestation services which is needed to
provision a private EPID key to the platform and to verify the status
of an enclave attestation quote from a remote platform.

In order to achieve the SGX/IAGO security model, a lot of this
functionality is implemented by choreographing exchanges between six
Intel supplied and signed enclaves.  Intel supplies source code to
these enclaves and understanding how all of this works requires an
understanding of that codebase as well.  To top if off there is also a
50K hunk of signed Java bytecode that gets stuffed into the Management
Engine if you are interested in platform services.

All of the above is what we wrote an independent implementation of, in
straight C, that is capable of linking against the MUSL C library with
only libelf and OpenSSL as dependencies.  We developed all of this to
support a reasonably sophisticated multi-enclave SGX security
application that implements modeling the runtime behavior of
applications running on the Linux kernel.  That application uses an
alternate enclave attestation and communications architecture that we
independently developed.

I don't describe the above to hype or promote what we do.  Everyone
discussing these issues is a professional software engineer or
architect.  As such, you will know that by the time you get done doing
all of the above, to the point where you are willing to take it to
Washington, DC to do live technology demonstrations to government
agencies with seven minutes of setup time, you are going to have to be
pretty confident that you know how all of the pieces are supposed to
go together.

Based on this experience, if the proposed driver lands in its current
state, Linux mainline will have, at least from a privacy perspective,
an inferior implementation of SGX.  In addition, we are not confident
the driver will be useful to anything other then server class hardware
and will be incapable of supporting virtually all of the existing SGX
hardware in the field.

This is NOT a criticism of Jarkko's work or the overall technical
implementation and quality of the driver.  We actually use and test a
modified version of the proposed driver, along with the out of tree
driver in our platforms.

At a high level, addressing these issues is straight forward.  First,
the driver needs to support authorization equivalent to that which is
implemented in the current Intel Launch Enclave, ie. control over the
SGX_FLAGS_PROVISION_KEY attribute.  Secondly, the driver needs to drop
its prohibition against launch enclaves, ie. returning EINVAL when a
request is made to initialize enclaves which have the
SGX_FLAGS_EINITTOKEN_KEY attribute set.

There will be some devil in the details with respect to both of these
issues, but those discussions can follow later.  Addressing these two
issues will at least create an environment where the proposed in-tree
driver is equivalent in privacy and functionality to the out of tree
driver.

SGX is a remarkably complex piece of machinery.  Producing a useful
driver requires the consideration of a lot of issues which, in our
opinion, have not been fully represented in the discussions to date.

> /Jarkko

I hope the above is useful for framing future discussions.

Have a good remainder of the week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I suppose that could could happen but he wouldn't know a Galois Field
 if it kicked him in the nuts."
                                -- Anonymous mathematician
                                   Resurrection.
