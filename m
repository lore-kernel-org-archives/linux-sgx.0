Return-Path: <SRS0=Z3oH=OF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD5AC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 18:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CA3720865
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 18:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VocPR2MR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CA3720865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbeK0FRa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Nov 2018 00:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725199AbeK0FRa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Nov 2018 00:17:30 -0500
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895FF20865
        for <linux-sgx@vger.kernel.org>; Mon, 26 Nov 2018 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543256554;
        bh=6hPGnLrV+QZcJMVsSvi/1YVZ8fpPO+ovW56LjFsKwBg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VocPR2MRw4c9XWZgoA0IaVVEKT8pvv0+VYpn8BQuDJUgWnPYJ7NkuVmjmIWFoLTe+
         PpilT/3ReRL6XbF9uzMGe/+sENE7K2k6eheJc0arHjf90orQvEdmtFyTJ24rqIADiM
         w7Nj9RLxS/YXWAcQ+Kz/3s5MRg0MZEL1uE2QX50U=
Received: by mail-wr1-f45.google.com with SMTP id p4so20001684wrt.7
        for <linux-sgx@vger.kernel.org>; Mon, 26 Nov 2018 10:22:34 -0800 (PST)
X-Gm-Message-State: AA+aEWbUYr0/UIjVnFnH/Tg9jM/x4xfp2jCj3hFsfMoeFXwv0VqEwNlF
        63O9f9Ui93+2u6Px6CcQSGTDq0OvadjuO6YcocDshA==
X-Google-Smtp-Source: AFSGD/Vv9cNgAyAhEPS2DxyGw96gqnMvWFvxMCsd8g/QKF3f3TXQ6z7q6JyqZVJaeK6/+08cBxDMxyURBD65oFTD164=
X-Received: by 2002:a5d:5541:: with SMTP id g1mr25339264wrw.330.1543256552960;
 Mon, 26 Nov 2018 10:22:32 -0800 (PST)
MIME-Version: 1.0
References: <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com>
 <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181125185524.GA23224@wind.enjellic.com>
 <D45BC005-5064-4C75-B486-4E43C454E2F6@amacapital.net> <94154ECB-3EF7-4A37-9057-0B84DBCE650E@amacapital.net>
 <20181126110038.GA27609@wind.enjellic.com>
In-Reply-To: <20181126110038.GA27609@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 26 Nov 2018 10:22:20 -0800
X-Gmail-Original-Message-ID: <CALCETrVdooOwt080-f-Sr92pnbRVchsffxWGnnEHmH40qLyCdA@mail.gmail.com>
Message-ID: <CALCETrVdooOwt080-f-Sr92pnbRVchsffxWGnnEHmH40qLyCdA@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     "Dr. Greg Wettstein" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 26, 2018 at 3:00 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Sun, Nov 25, 2018 at 04:37:00PM -0800, Andy Lutomirski wrote:
>
> > Bah, I hit send on a partially written draft. I???ll try again soon.
> >
> > --Andy
>
> Your first issue seems to be complete so I will respond to that in
> order to make sure we are not talking past one another.

It wasn't, but your answer is enlightening!  I've read the SGX
*manual*, but I hadn't dug through the actual Intel-supplied enclaves.
So, when I said that the LE isn't an important part of the overall
trust model, I meant that it isn't *in hardware*.  It's certainly
possible to write SGX software that weakens the security of the
overall system, and Intel seems to have done so:

>
> The Intel supplied launch enclave (LE) specifically denies
> initialization of enclaves which have the PROVISION attribute set,
> with the exception of enclaves whose MRSIGNER values match those of
> the keys that Intel uses to sign the PCE and PVE enclaves.  See line
> 219 of psw/ae/le/launch_enclave.cpp in the Intel SDK.

This seems entirely reasonable.  (But see below...)

> This report, along with the PEK, is submitted to the PCE enclave in
> order to generate the Platform Provisioning IDentity (PPID), which is
> the privacy critical identifier.  The PCE verifies the report
> generated by the PVE and rejects the request to generate the PPID if
> the report was generated by an enclave that was not initialized with
> the PROVISION bit set, see line 109 of psw/ae/pce/pce.cpp.

...and this seems entirely unreasonable.  Your description does indeed
appear consistent with the code: the PCE will hand out the PPID to any
requesting enclave that has the PROVISION bit set, so you are correct
that:

> Once again, the important design factor in all of this is the premise
> that the launch enclave will not allow enclaves other then the PCE and
> PVE to access the PROVISION bit.

But here's where the whole thing goes off the rails.  I would argue
that the Intel-supplied (and Intel-signed, apparently!) PCE is just
straight-up buggy.  What Intel is *trying* to do is to hand out the
PPID to an appropriately signed enclave.  What they actually did is to
hand out the PPID to any enclave that has the PROVISION bit set.  This
is poor design because it overload the PROVISION bit.  That bit is
supposed to mean "may use EGETKEY to obtain provisioning and
provisioning seal keys", which is not actually what Intel wants here.
It's also poor design without FLC because it pointlessly relies on the
LE to enforce a restriction on the use of provisioning enclaves, when
the code could instead have checked MRSIGNER..  And it's just straight
up wrong with FLC because there is no guarantee whatsoever that the LE
being used is Intel's.  And, for that matter, there is no guarantee
that the requesting enclave doesn't have the DEBUG bit set.

(It's also poor design because the PCE doesn't appear to verify that
the report passed in is actually intended to be associated with a call
to get_ppid().  There appear to be reports associated with provision
"msg1" and "msg3".  If it's possible to get a valid report for msg3 to
be accepted as a msg1 report of vice versa, then it might be game
over.)

Sorry, but this is not Linux's problem.  The right fix is, in my
opinion, entirely clear: the PCE should check MRSIGNER and possibly
even MRENCLAVE in the report it receives.  Intel needs to fix their
PCE, sign a fixed version, and find some way to revoke, to the extent
possible, the old one.  And the SGX enclave authors need to understand
something that is apparently subtle: THE LAUNCH POLICY IS NOT PART OF
THE TCB AND SHOULD NOT BE RELIED UPON.  Enclaves can and should be
written to remain secure even in the complete absence of any form of
launch control.

I went and filed a bug on github.  Let's see what happens:

https://github.com/intel/linux-sgx/issues/345

Also, the whole SGX report mechanism seems to be misused in the SDK.
An SGX report is a cryptographic primitive that essentially acts like
a signed blob.  Building a secure protocol on top of signed messages
or on top of reports takes more than just making up ad hoc blob
formats and signing them.  There needs to be domain separation between
different messages, and this seems to be entirely missing.  Do you
know if Intel has had a serious audit of their platform enclave code
done?

>
> > No, I have no clue why Intel did it this way.  I consider it to be a
> > mistake.
>
> Are you referring to there being a mistake in the trust relationships
> that the provisioning protocol implements or the overall concept of a
> provisioning key?

I'm referring to the hardware's policy as to when keys that don't
depend on OWNEREPOCH can be obtained.  As far as I know, the only real
need for such keys is to verify that the running platform is a real
Intel platform, which means that access to the provisioning key is
only useful to Intel-approved services.  Why didn't Intel enforce this
in hardware or microcode?  I see no reason that EGETKEY should hand
out those key types of the enclave is not signed by Intel.  For that
matter, I also don't see why the provisioning seal key needs to exist
-- the regular seal key could be used instead and, if OWNEREPOCH
changes, the platform could just re-certify itself.

> > >> The driver should establish the equivalent of three linked lists,
> > >> maintainable via /sysfs pseudo-files or equivalent plumbing.  The
> > >> lists are referenced by the kernel to enforce the following policies.
> > >>
> > >> 1.) The right to initialize an enclave without special attributes.
> > >>
> > >> 2.) The right to initialize an enclave with the PROVISION_KEY attribute set.
> > >>
> > >> 3.) The right to initialize an enclave with the LICENSE_KEY attribute set.
> > >>
> > >> The lists are populated with MRSIGNER values of enclaves that are
> > >> allowed to initialize under the specified conditions.
>
> > NAK because this is insufficient.  You're thinking of a model in
> > which SGX-like protection is all that's needed.  This is an
> > inadequate model of the real world.  The attack I'm most concerned
> > about wrt provisioning is an attack in which an unauthorized user is
> > permitted.
>
> We will be interested in your comments as to why the proposal is
> insufficient in the real world of FLC.

That's what you get for reading my unfinished email :)

Your proposal fails to protect against SGX malware.  Here's an SGX
malware use case: the attacker writes a malicious enclave and gets a
victim machine to run it as a non-root user.  They bundle it with a
valid Intel-signed copy of the relevant platform enclaves and use them
to bootstrap the attestation process.  The malicious enclave attests
its identity to a command-and-control server and obtains malicious
code to run.  The good guys can't reverse engineer the malware
enclave, because they can't pass the attestation check and therefore
can't obtain the encrypted code.

This isn't prevented by your proposed solution: the provisioning
enclaves are all signed by Intel.  What's needed is a check that
prevents unauthorized *users* from running them.

--Andy
