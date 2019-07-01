Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85307C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 582F3206A3
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562009579;
	bh=ziupIDluryvJgMAzf5H0Vi0YavM+fEiqtmmoNA62bzg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=iY/R76E8t1iitrd+cqyBjzML8s3YWPFWqa5TBJ1DXQF7eZIS6JAckczv2WW9/o3VR
	 hEOm3mVSJuB9JlaNLWFssAbcDFultcVUXeN849r9q5ZEK+DNs7fvpLl8Wo/pSE9RnT
	 XLz9BgQ+LGZrwfijsVivqVUONLPL+++fqtzHNVf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfGATc7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfGATc6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 15:32:58 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56BE221721
        for <linux-sgx@vger.kernel.org>; Mon,  1 Jul 2019 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562009577;
        bh=ziupIDluryvJgMAzf5H0Vi0YavM+fEiqtmmoNA62bzg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G2mpPKRektFSwOhc4wdHFPIVLFFn/IhlHUi5MhJfHSWe0NV8xyOeU/BzO8Ab2gER9
         K38f4LlX2NQVIsFY49VOwqUFcBRxgGmRou5HsrQNTrfvuQaZeQy5vcuLpOBfIC5JW5
         3Lek+4s9j45hYDVGEIHLPo+t8YkiI7cxe4Puu3PQ=
Received: by mail-wr1-f50.google.com with SMTP id p11so15084652wre.7
        for <linux-sgx@vger.kernel.org>; Mon, 01 Jul 2019 12:32:57 -0700 (PDT)
X-Gm-Message-State: APjAAAXxOV+MElE0zDcYzanjX+EM0Nsiz9A6SaNlMb0zfcXvrD4ZPyY7
        JrLnVzSi0+XOQWUK6ZJhMQvYi5I5IWK/YFBIxG+8bg==
X-Google-Smtp-Source: APXvYqztPnVyAHGvo92uX8JHGB+CXgP+a/o6R5tZaK2g6mNBe0FhsydWtCQ4uUzAhIu0abROw7rXm0n0BKNwcaJP9i4=
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr17290143wrm.265.1562009575930;
 Mon, 01 Jul 2019 12:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com> <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov> <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D558@ORSMSX116.amr.corp.intel.com>
 <CALCETrXjq9JNjXZo3Va83Ca7fiAJx7ZM9VRWYebzpyH6ug0cKg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 1 Jul 2019 12:32:44 -0700
X-Gmail-Original-Message-ID: <CALCETrU=Btr+o9jb-zbj2kw8571WGhuhA6ZdttxQ_5_3pzZwUw@mail.gmail.com>
Message-ID: <CALCETrU=Btr+o9jb-zbj2kw8571WGhuhA6ZdttxQ_5_3pzZwUw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/12] security/selinux: Add enclave_load() implementation
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 1, 2019 at 11:54 AM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: Andy Lutomirski [mailto:luto@kernel.org]
> > Sent: Monday, July 01, 2019 10:54 AM
> >
> > On Mon, Jul 1, 2019 at 10:46 AM Xing, Cedric <cedric.xing@intel.com>
> > wrote:
> > >
> > > > From: Andy Lutomirski [mailto:luto@kernel.org]
> > > > Sent: Saturday, June 29, 2019 4:42 PM
> > > >
> > > > On Tue, Jun 25, 2019 at 2:09 PM Stephen Smalley <sds@tycho.nsa.gov>
> > > > wrote:
> > > > >
> > > > > On 6/21/19 5:22 PM, Xing, Cedric wrote:
> > > > > >> From: Christopherson, Sean J
> > > > > >> Sent: Wednesday, June 19, 2019 3:24 PM
> > > > > >>
> > > > > >> Intended use of each permission:
> > > > > >>
> > > > > >>    - SGX_EXECDIRTY: dynamically load code within the enclave
> > itself
> > > > > >>    - SGX_EXECUNMR: load unmeasured code into the enclave, e.g.
> > > > > >> Graphene
> > > > > >
> > > > > > Why does it matter whether a code page is measured or not?
> > > > >
> > > > > It won't be incorporated into an attestation?
> > > > >
> > > >
> > > > Also, if there is, in parallel, a policy that limits the set of
> > > > enclave SIGSTRUCTs that are accepted, requiring all code be measure=
d
> > > > makes it harder to subvert by writing incompetent or maliciously
> > > > incompetent enclaves.
> > >
> > > As analyzed in my reply to one of Stephen's comments, no executable
> > page shall be "enclave only" as enclaves have access to host's memory,
> > so if an executable page in regular memory is considered posting a
> > threat to the process, it should be considered posting the same threat
> > inside an enclave as well.
>
> What I was trying to say was, an executable page, if considered a threat =
to the enclosing process, should always be considered a threat no matter it=
 is in that process's memory or inside an enclave enclosed in that same pro=
cess's address space.
>
> Therefore, for a page in regular memory, if it is denied executable, it i=
s because it is considered a potential security threat to the enclosing pro=
cess, so it shall not be used as the source for an executable enclave page,=
 as the same threat exists regardless it is in regular memory or EPC. Does =
that make more sense?

It does make sense, but I'm not sure it's correct to assume that any
LSM policy will always allow execution on enclave source pages if it
would allow execution inside the enclave.  As an example, here is a
policy that seems reasonable:

Task A cannot execute dynamic non-enclave code (no execmod, no
execmem, etc -- only approved unmodified file pages can be executed).
But task A can execute an enclave with MRENCLAVE =3D=3D such-and-such, and
that enclave may be loaded from regular anonymous memory -- the
MRENCLAVE is considered enough verification.

>
> My patch doesn't require X on source pages either. I said "would", meanin=
g X *would* be granted but doesn't have to be granted. You can see this in =
selinux_enclave_load() calling selinux_file_mprotect() in my code. The purp=
ose is to determine if X *would* be granted to the source pages without act=
ually granting X.

As above, I'm not convinced this assumption is valid.
