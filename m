Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AB2C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 523C020879
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="e4/CpAO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbfEXRvF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 13:51:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32841 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731910AbfEXRvE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 24 May 2019 13:51:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id g21so4471570plq.0
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 10:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ocLpeABc0HQG8VakKMn2nzLynuB7SdZa/fkKOnImdKM=;
        b=e4/CpAO0cLXVFJXkjwP4Q7OvrYfhoyHJdNe2WEcZMZJnJDciggEGccrFo8JVoGXtb5
         b+zlU3vEDkzcWrUZTvrPARbOM8V3XuERPwDfVYLz3nWYcwpRJtEcMv9ONyyYFXSyTIpg
         m4VAyWJawqnztcr3Ph4Y4uyNnv7qZkXYF2a+jg4eC/vvGD8tWIArlWDDO/1L4cy2Qbyi
         CK/+ImPgjQegUn/M/oIkFxI6j4XduMpxad9NQmsJwVRPlODAOfilPBrHk4icV0RFXCA4
         uhas3dPiAbiPZXa+hw/CwbyhY7fx+X6PmhYKDuTJwMyZU50MFV80XP55bCuIjzGlG9EK
         tMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ocLpeABc0HQG8VakKMn2nzLynuB7SdZa/fkKOnImdKM=;
        b=jZSGy32MOk3GQsfidpYljXZ70g/E/uRW2M+oQeTLFl6itrDckGC126n11O3M0OE8Yd
         YGv/HMz+VTevd91C6dPZsunPDkY6awyksQhWiidURbOfi/WgZf19rfMudX5yk8VyrVzV
         DXEuk0t4PgKYM8Y2qsuJC+jQQicWRteOxsbIhsBoOoU5NuaxgxV/3ZJqzM918aYryP0A
         HfgjulCfP6X/JVeBPBuonVqNInuPWPt6TaQnn8IKTb/Rm2K1eroJxP1nbde4k4NKbOdE
         xNiXOxmHjNzOFQk8u1BJmCAhqX6ZAEIpGDUi7zwVKOZWoHl6+6IsniwtDrjJ0BXQGtH9
         UHYQ==
X-Gm-Message-State: APjAAAXWkqVTv3vVHx296wMjqRMWYO/dErEgM+XFY+KeD0K4XE3+EnVv
        O43LjpKYsXKPQJLSMhHjk3xXCw==
X-Google-Smtp-Source: APXvYqzzY81ZrfYrcbzt983IOgBBG5J0RNb114wVXJ/FR0byAfcIPsoMJBqiR3z1BlD8XAqhWlGIrg==
X-Received: by 2002:a17:902:10c:: with SMTP id 12mr107916591plb.61.1558720264308;
        Fri, 24 May 2019 10:51:04 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:25e7:e273:cc72:2b04? ([2601:646:c200:1ef2:25e7:e273:cc72:2b04])
        by smtp.gmail.com with ESMTPSA id 12sm8835425pfs.106.2019.05.24.10.51.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:51:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190524170704.GA3401@linux.intel.com>
Date:   Fri, 24 May 2019 10:51:02 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D1F8869E-7431-4D73-8571-8F4F187B8632@amacapital.net>
References: <20190522153836.GA24833@linux.intel.com> <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com> <20190523023517.GA31950@linux.intel.com> <20190523102628.GC10955@linux.intel.com> <20190523141752.GA12078@linux.intel.com> <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com> <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com> <CALCETrX0WqouSWgdM+LNxMzypa0ZHZXTmJ+nNkuPuL8UOF_f2w@mail.gmail.com> <20190524170704.GA3401@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On May 24, 2019, at 10:07 AM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>=20
>> On Fri, May 24, 2019 at 09:43:27AM -0700, Andy Lutomirski wrote:
>>> On Fri, May 24, 2019 at 12:24 AM Xing, Cedric <cedric.xing@intel.com> wr=
ote:
>>> /**
>>> * Summary:
>>> * - The enclave file resembles a shared object that contains RO/RX/RW se=
gments
>>> * - FILE__* are assigned to /dev/sgx/enclave, to determine acceptable pe=
rmissions to mmap()/mprotect(), valid combinations are
>>> *   + FILE__READ - Allow SGX1 enclaves only
>>> *   + FILE__READ|FILE__WRITE - Allow SGX2 enclaves to expand data segmen=
ts (e.g. heaps, stacks, etc.)
>>=20
>> I think this is a non-starter :(  FILE__WRITE also means that you can
>> write to the file, and the admin / policy author will almost never
>> want to allow that.
>=20
> Why would FILE__WRITE on /dev/sgx/enclave be a problem?  An actual
> write to /dev/sgx/enclave would yield -EINVAL, no?

Bah, read it wrong =E2=80=94 FILE__WRITE on the enclave file on disk is no g=
ood.=
