Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90536C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 20:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CCC2082E
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 20:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="sgC8USHJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfEQUOE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 16:14:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33521 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfEQUOD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 16:14:03 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so3806017pgv.0
        for <linux-sgx@vger.kernel.org>; Fri, 17 May 2019 13:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=djiAluF6Os7TIFCRa6Lz/pNs4CAEzPaAGQb3bIhp0AI=;
        b=sgC8USHJylMmTugxbrJIZExCFRu3pVa9hcPmCcK4p6hSAcQrxxlnFPE9W7VZX26LMv
         +NNIg5GUmvKrN+cTLBJl/W6v9t6AXRsn5rDKXTNt4zdcYR9IKTGc84dXHM/Glg4EjJq6
         conKdsD9PcOd7Zj6sVOgFGJrZYyH9Ivqh3nF3JuwyJpSfxmUwlPcmqEv9DIsPXydTmFJ
         q9vlpsao5402l3yk/NcX0qpkHGDXUopZJW1RbyqIUWQ+f19tKMX0TpqtY5dgRy5l8nKg
         Q+E3mqN4/jQT26rO4mayqwt80PqDym/fxXRA6C91Fu/2zZQ+NRo0SVqZ/9ayzrNNsHXl
         nlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=djiAluF6Os7TIFCRa6Lz/pNs4CAEzPaAGQb3bIhp0AI=;
        b=ITEwvehevyq3tem55kUtb0+abDkxthsZCnOagYWBtx7VXF9MtKgCTc4q7oWOfq8JAB
         e9RW+2zY6Kv6j4q+rGH8a2FH6pwd3Tpe3fYTS/hVEW3glv7MQTaHdlQ01DAiOWvUoleh
         CLgTQ6ZxARugQNSDH5lav5vgwWkd+bZmwTVF+50bCC/Pb08GIDjzZaDEsc8LLwjxx4ZH
         NFLH6WVVm4/FFLJdBFaHsTFYR/DiS16TuyMclQb6UeOAM/NNjoXZIFYWsduJqQ+S3idr
         G1ZGFXAK/6+SgZHZQ6VHpHHPqPvG6CNU6u270+4vF/FPtdPxfA8fyx212OImSv9SNM7w
         Jc5Q==
X-Gm-Message-State: APjAAAXLTrjd2/u0rXH72hcGhVI3PwVndOm9gUd3u5d+Tr2pxU+3+SPh
        URWd3CHX8YECDEegTsnDrBfSZA==
X-Google-Smtp-Source: APXvYqxqEHlR2LaL8nj/xNhZ/tyfEOKQIe177n5+LgtmYcJFfb2KwNTDT0V0qu3unH8GKzQuLagvyA==
X-Received: by 2002:a63:dd4a:: with SMTP id g10mr5357469pgj.419.1558124042986;
        Fri, 17 May 2019 13:14:02 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:3dbf:4623:7293:192d? ([2601:646:c200:1ef2:3dbf:4623:7293:192d])
        by smtp.gmail.com with ESMTPSA id u6sm15468121pfa.1.2019.05.17.13.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 13:14:01 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <c901ea99-5b43-a25d-03e8-55b4fce9c466@tycho.nsa.gov>
Date:   Fri, 17 May 2019 13:14:00 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-Id: <ED98AEC9-FFA3-4DA4-9B86-11D8AADC9151@amacapital.net>
References: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com> <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com> <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov> <20190517150948.GA15632@linux.intel.com> <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov> <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov> <837CE33B-A636-4BF8-B46E-0A8A40C5A563@amacapital.net> <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov> <20190517192823.GG15006@linux.intel.com> <c901ea99-5b43-a25d-03e8-55b4fce9c466@tycho.nsa.gov>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On May 17, 2019, at 1:09 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>=20
>> On 5/17/19 3:28 PM, Sean Christopherson wrote:
>>> On Fri, May 17, 2019 at 02:05:39PM -0400, Stephen Smalley wrote:
>>>> On 5/17/19 1:12 PM, Andy Lutomirski wrote:
>>>>=20
>>>> How can that work?  Unless the API changes fairly radically, users
>>>> fundamentally need to both write and execute the enclave.  Some of it w=
ill
>>>> be written only from already executable pages, and some privilege shoul=
d be
>>>> needed to execute any enclave page that was not loaded like this.
>>>=20
>>> I'm not sure what the API is. Let's say they do something like this:
>>>=20
>>> fd =3D open("/dev/sgx/enclave", O_RDONLY);
>>> addr =3D mmap(NULL, size, PROT_READ | PROT_EXEC, MAP_SHARED, fd, 0);
>>> stuff addr into ioctl args
>>> ioctl(fd, ENCLAVE_CREATE, &ioctlargs);
>>> ioctl(fd, ENCLAVE_ADD_PAGE, &ioctlargs);
>>> ioctl(fd, ENCLAVE_INIT, &ioctlargs);
>> That's rougly the flow, except that that all enclaves need to have RW and=

>> X EPC pages.
>>> The important points are that they do not open /dev/sgx/enclave with wri=
te
>>> access (otherwise they will trigger FILE__WRITE at open time, and later
>>> encounter FILE__EXECUTE as well during mmap, thereby requiring both to b=
e
>>> allowed to /dev/sgx/enclave), and that they do not request PROT_WRITE to=
 the
>>> resulting mapping (otherwise they will trigger FILE__WRITE at mmap time)=
.
>>> Then only FILE__READ and FILE__EXECUTE are required to /dev/sgx/enclave i=
n
>>> policy.
>>>=20
>>> If they switch to an anon inode, then any mmap PROT_EXEC of the opened f=
ile
>>> will trigger an EXECMEM check, at least as currently implemented, as we h=
ave
>>> no useful backing inode information.
>> Yep, and that's by design in the overall proposal.  The trick is that
>> ENCLAVE_ADD takes a source VMA and copies the contents *and* the
>> permissions from the source VMA.  The source VMA points at regular memory=

>> that was mapped and populated using existing mechanisms for loading DSOs.=

>> E.g. at a high level:
>> source_fd =3D open("/home/sean/path/to/my/enclave", O_RDONLY);
>> for_each_chunk {
>>         <hand waving - mmap()/mprotect() the enclave file into regular me=
mory>
>> }
>> enclave_fd =3D open("/dev/sgx/enclave", O_RDWR); /* allocs anon inode */
>> enclave_addr =3D mmap(NULL, size, PROT_READ, MAP_SHARED, enclave_fd, 0);
>> ioctl(enclave_fd, ENCLAVE_CREATE, {enclave_addr});
>> for_each_chunk {
>>         struct sgx_enclave_add ioctlargs =3D {
>>                 .offset =3D chunk.offset,
>>                 .source =3D chunk.addr,
>>                 .size   =3D chunk.size,
>>                 .type   =3D chunk.type, /* SGX specific metadata */
>>         }
>>         ioctl(fd, ENCLAVE_ADD, &ioctlargs); /* modifies enclave's VMAs */=

>> }
>> ioctl(fd, ENCLAVE_INIT, ...);
>> Userspace never explicitly requests PROT_EXEC on enclave_fd, but SGX also=

>> ensures userspace isn't bypassing LSM policies by virtue of copying the
>> permissions for EPC VMAs from regular VMAs that have already gone through=

>> LSM checks.
>=20
> Is O_RDWR required for /dev/sgx/enclave or would O_RDONLY suffice?  Do you=
 do anything other than ioctl() calls on it?
>=20
> What's the advantage of allocating an anon inode in the above?  At present=
 anon inodes are exempted from inode-based checking, thereby losing the abil=
ity to perform SELinux ioctl whitelisting, unlike the file-backed /dev/sgx/e=
nclave inode.
>=20
> How would SELinux (or other security modules) restrict the authorized encl=
aves that can be loaded via this interface?  Would the sgx driver invoke a n=
ew LSM hook with the regular/source VMAs as parameters and allow the securit=
y module to reject the ENCLAVE_ADD operation?  That could be just based on t=
he vm_file (e.g. whitelist what enclave files are permitted in general) or i=
t could be based on both the process and the vm_file (e.g. only allow specif=
ic enclaves to be loaded into specific processes).

This is the idea behind the .sigstruct file. The driver could call a new hoo=
k to approve or reject the .sigstruct. The sigstruct contains a hash of the w=
hole enclave and a signature by the author.=
