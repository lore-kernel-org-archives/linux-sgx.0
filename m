Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBDBC19425
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 19:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD24023609
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 19:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgLITds (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 14:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgLITdl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Dec 2020 14:33:41 -0500
X-Gm-Message-State: AOAM532aunpb9wskBLPGosFlUA6dkwMNDUvvlzAtR9S7nz1XI+6JUO5Y
        NsfJ7DtQd+h56EpuD5GuXQQ56JxVNTUUgqQDMDwbvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607542380;
        bh=NM6jro1bAPh43j8v/jVR5yx6rrw+/TmsQOV/h3WV/QI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L977ZHA72vgx0IqxNJkisz1Tbv002KwFBbpAXO2kaDx+pF0CCg0kaWQ3p/7StNn/Q
         ZlFVtXevQ0BTs/giCt4zS6fbXthdI16THWAQYcjmT70Qmh1WWOeo6csGX+u0Ua5Fba
         YfLBNpJxCllQ5zrGv4EUtauQi/4+q5kQp39wseVeuOrKLHgsA8Q5P9ejryseicupWk
         /aXw5+eV0THzT1SQy1vhfeoiMbjWiscDb2U0rhr6dyw/fp4zPsnY0GQmY3CtNy0J3f
         ihiFT+EqbiALeiIzrVbeYf39szYBkG9aRvlG4dtlxUpitQzOTRtVkI/fujKw68+HGe
         FJfTjhyCY0AeQ==
X-Google-Smtp-Source: ABdhPJxkD1hv140qA3MrC498W8XJlQAEkEL0k7G7NwkuzkFcl2pn5GyllHHRRWbDRuEB/1AnKm6pxrSlegvFpNx/MjM=
X-Received: by 2002:a1c:1d85:: with SMTP id d127mr4510686wmd.49.1607542378445;
 Wed, 09 Dec 2020 11:32:58 -0800 (PST)
MIME-Version: 1.0
References: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
 <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net> <293dd2c6-972f-b2ae-666e-aa6b01b94b26@gmail.com>
In-Reply-To: <293dd2c6-972f-b2ae-666e-aa6b01b94b26@gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 9 Dec 2020 11:32:47 -0800
X-Gmail-Original-Message-ID: <CALCETrWGaBPwfqcsvAx9AF94koggK4FCNDfarmcRvoTa5BgR-Q@mail.gmail.com>
Message-ID: <CALCETrWGaBPwfqcsvAx9AF94koggK4FCNDfarmcRvoTa5BgR-Q@mail.gmail.com>
Subject: Re: Creating executable device nodes in /dev?
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        =?UTF-8?Q?Zbigniew_J=C4=99drzejewski=2DSzmek?= <zbyszek@in.waw.pl>,
        linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 9, 2020 at 11:22 AM Topi Miettinen <toiwoton@gmail.com> wrote:
>
> On 9.12.2020 17.14, Andy Lutomirski wrote:
> >

> Maybe also malware which can escape all means of detection, enforced by
> the CPU? Though I don't know if any malware scanners for Linux work can
> check for fileless, memory only malware.

I don't think this is really relevant to malware detection.  You can't
do syscalls from SGX code, for example, and, even if you could,
malware behavior analysis would be unaffected.  The concern seems to
be more that, once someone has discovered some malware, if it's
protected by SGX then it's plausible that you can't disassemble it.

>
> >
> > In Intel=E2=80=99s original vision, only specially licensed vendors cou=
ld create SGX software, but Linux pushed back against this quite hard, and =
new CPUs allow unlicensed enclaves. So your Skylake CPUs support SGX, but n=
ot on Linux.
>
> Kudos to Linux for the push.

:)

I don't know if Linux gets full credit for this, but I think we at
least had some impact.
