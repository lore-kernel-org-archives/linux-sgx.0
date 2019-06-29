Return-Path: <SRS0=WPzH=U4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2798FC4646D
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 01:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F34FA2133F
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 01:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iS2rkfA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfF2Bht (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 21:37:49 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40597 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF2Bht (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jun 2019 21:37:49 -0400
Received: by mail-io1-f65.google.com with SMTP id n5so16376321ioc.7;
        Fri, 28 Jun 2019 18:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s0IWaihDnBCfC44+rfDjNQFXWoezz0NpBvOnP0BGdrA=;
        b=iS2rkfA4VEYIGqei/JnvJ7RG1v8YjdoC4HxeH7YdpO0YgmEBLARGrxMsziYzkzS8VR
         R4EMxH9553jgl/or1+XRs9lVAjFM1+R0MnG84Aqsfh5gWozPh7ZqP4K/+0MAYUgZgWRA
         MDiSBIMhT7rZ76FEnSz0P06A9mSH6ICHLtXbldZey4hms7jaKIE2cUK495l3UCacb4W/
         JZ3CtIwUrHeRFWX/k4C6Fxy5H/W4dnc5pk6mRiB1DCzooXQtvenxI4IbjLihb2TkEngB
         6Nm/OoxN/h/EIvuo7JkxlyZNn3WkulAX/IT8aD93UfRlbKwwMsvmL9UoDc8nvFCXcM52
         frEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s0IWaihDnBCfC44+rfDjNQFXWoezz0NpBvOnP0BGdrA=;
        b=sq/hzBTaBudQnq11b0oswD3Km/wR2zuVw2UApUmQUdbrY/GEknVlUvG5aDF1nEf1KF
         JmnbEJPz9LDjls3nLkwpiyLenZTSPQQoBMKcxVY1Wh37i5ZsfsTktH2UBCbwgoVHuCiN
         j31vMNNCli6+zojFY5pDi9nSZGenVBCuqHW58htzqs4LCSHwOI5tx2yYyf9eiWb5NYg5
         dQVQ35739B54zpASrcSaNi++w+cJQiGr1pCV8EjA/XG1t/DboGyTmUeTIJM0XBWtG3G1
         uwwRn2m4f40+M15HIgFsAjfc4Q2vxIovacedqJpRVLmndwHjb2/kE5TEOz0ck+sA2R27
         EO/g==
X-Gm-Message-State: APjAAAXrM1EiY+Nc+Xp32Nn0caIb+0V8fCtQhkPfp9HKr9fe9GtKNUh8
        t7vY0A8ouOZA2u3JM7DEQm7Ws5dswrRiv6HRyyc=
X-Google-Smtp-Source: APXvYqyVQLDfgupeNjJQEWErt1GXAM/ulZ/oWnUz+vx4xY9wNe2VpcVA1K9XA6YODZjmzj493mX2Jk6Dd8ZL6XUzn1I=
X-Received: by 2002:a02:4484:: with SMTP id o126mr15245453jaa.34.1561772267473;
 Fri, 28 Jun 2019 18:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561588012.git.cedric.xing@intel.com> <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
 <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
 <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com>
In-Reply-To: <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com>
From:   Stephen Smalley <stephen.smalley@gmail.com>
Date:   Fri, 28 Jun 2019 21:37:35 -0400
Message-ID: <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 28, 2019 at 1:22 PM Casey Schaufler <casey@schaufler-ca.com> wr=
ote:
>
> On 6/27/2019 5:47 PM, Xing, Cedric wrote:
> >> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
> >> Sent: Thursday, June 27, 2019 4:37 PM
> >>>> This code should not be mixed in with the LSM infrastructure.
> >>>> It should all be contained in its own module, under security/enclave=
.
> >>> lsm_ema is *intended* to be part of the LSM infrastructure.
> >> That's not going to fly, not for a minute.
> > Why not, if there's a need for it?
> >
> > And what's the concern here if it becomes part of the LSM infrastructur=
e.
>
> The LSM infrastructure provides a framework for hooks
> and allocation of blobs. That's it. It's a layer for
> connecting system features like VFS, IPC and the IP stack
> to the security modules. It does not implement any policy
> of it's own. We are not going to implement SGX or any other
> mechanism within the LSM infrastructure.

I don't think you understand the purpose of this code.  It isn't
implementing SGX, nor is it needed by SGX.
It is providing shared infrastructure for security modules, similar to
lsm_audit.c, so that security modules can enforce W^X or similar
memory protection guarantees for SGX enclave memory, which has unique
properties that render the existing mmap and mprotect hooks
insufficient. They can certainly implement it only for SELinux, but
then any other security module that wants to provide such guarantees
will have to replicate that code.

>
> >>>  It is going to be shared among all LSMs that would like to track
> >> enclave pages and their origins.
> >>
> >> That's true for InfiniBand, tun and sctp as well. Look at their
> >> implementations.
> > As far as I can tell, InfiniBand, tun and sctp, all of them seemed used=
 inside SELinux only.
>
> So?
>
> > If you had a chance to look at v1 of my series, I started by burying ev=
erything inside SELinux too. But Stephen pointed out such tracking would be=
 needed by all LSMs so code duplication might be a concern. Thus I responde=
d by moving it into LSM infrastructure.
>
> What you need to do is move all the lsm_ema code into its own
> place (which could be security/enclave). Manage your internal
> data as you like. LSMs (e.g. SELinux) can call your APIs if
> needed. If the LSMs need to store SGX information with the file
> structure they need to include that in the space they ask for in
> the file blob.
>
>
> >>> And they could be extended to store more information as deemed
> >> appropriate by the LSM module.
> >>
> >> Which is what blobs are for, but that does not appear to be how
> >> you're using either the file blob or your new ema blob.
> > A lsm_ema_map pointer is stored in file->f_security.
>
> That's up to the individual security module to decide.
>
> >  Each lsm_ema_map contains a list of lsm_ema structures. In my last pat=
ch, SELinux stores a ema_security_struct with every ema, by setting selinux=
_blob_sizes.lbs_ema_data to sizeof(ema_security_struct).
>
> You are managing the ema map lists. You don't need the LSM
> infrastructure to do that.
>
> > ema_security_struct is initialized in selinux_enclave_load(), and check=
ed in enclave_mprotect(), which is a subroutine of selinux_file_mprotect().=
 BTW, it is alloced/freed automatically by LSM infrastructure in security_e=
nclave_load()/security_file_free().
>
> Do you mean security_enclave_load()/security_enclave_free() ?
> There is no way you can possibly have sane behavior if you're
> allocation and free aren't tied to the same blob.
>
> >>>  The last patch of this series shows how to extend EMA inside SELinux=
.
> >> I don't see (but I admit the code doesn't make a lot of sense to me)
> >> anything you couldn't do in the SELinux code by adding data to the
> >> file blob. The data you're adding to the LSM infrastructure doesn't
> >> belong there, and it doesn't need to be there.
> > You are correct. My v1 did it inside SELinux.
> >
> > The key question I think is whether only SELinux needs it, or all LSMs =
need it. Stephen thought it was the latter (and I agree with him) so I move=
d it into the LSM infrastructure to be shared, just like the auditing code.
>
> You are both right that it doesn't belong in the SELinux code.
> It also doesn't belong as part of the LSM infrastructure.
>
> >>>> Not acceptable for the LSM infrastructure. They
> >>>> are inconsistent with the way data is used there.
> >>> I'm not sure I understand this comment.
> >> It means that your definition and use of the lsm_ema_blob
> >> does not match the way other blobs are managed and used.
> >> The LSM infrastructure uses these entries in a very particular
> >> way, and you're trying to use it differently. Your might be
> >> able to change the rest of the enclave system to use it
> >> correctly, or you might be able to find a different place
> >> for it.
> > I'm still not sure why you think this (lbs_ema_data) is inconsistent wi=
th other blobs.
> >
> > Same as all other blobs, an LSM requests it by storing the needed size =
in it, and is assigned an offset, and the buffer is allocated/freed by the =
infrastructure. Am I missing anything?
>
> Yes. Aside from allocation and deletion the infrastructure does
> nothing with the blobs. The blobs are used only by the security
> modules. All other data is maintained and used elsewhere. SGX
> specific data needs to me maintained and managed elsewhere.
>
> >>> As I stated in the cover letter, the primary question is how to
> >> prevent SGX from being abused as a backdoor to make executable pages
> >> that would otherwise not be executable without SGX. Any LSM module
> >> unaware of that would leave that "hole" open. So tracking enclave page=
s
> >> will become a common task for all LSMs that care page protections, and
> >> that's why I place it inside LSM infrastructure.
> >>
> >> Page protections are an important part of many security features,
> >> but that's beside the point. The LSM system provides mechanism for
> >> providing additional restrictions to existing security mechanisms.
> >> First, you create the security mechanism (e.g. enclaves) then you
> >> add LSM hooks so that security modules (e.g. SELinux) can apply
> >> their own policies in addition. In support of this, the LSM blob
> >> mechanism allows security modules to maintain their own information
> >> about the system components (e.g. file, inode, cred, task) they
> >> care about. The LSM infrastructure does not itself provide or
> >> support security data or policy. That's strictly for the modules
> >> to do.
> > Agreed!
> >
> > EMA doesn't dictate policies for sure. Is it considered "security data"=
? I'm not sure the definition of "security data" here. It does store some "=
data", something that multiple LSM modules would need to duplicate if not p=
ulled into a common place. It is meant to be a "helper" data structure, jus=
t like the auditing code.
>
> Good example. You'll see that there is no audit code in the
> LSM infrastructure. None. No audit data, either. It's all taken
> care of in the audit system.
>
>
