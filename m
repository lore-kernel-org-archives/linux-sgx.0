Return-Path: <SRS0=Z3oH=OF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBC2C43441
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 00:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D946720865
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 00:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="Qe8/I/So"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D946720865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbeKZL32 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Nov 2018 06:29:28 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40089 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeKZL32 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 26 Nov 2018 06:29:28 -0500
Received: by mail-pf1-f195.google.com with SMTP id i12so5684463pfo.7
        for <linux-sgx@vger.kernel.org>; Sun, 25 Nov 2018 16:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hW5H5eUlUgTpOIzdNNZ8H532v4I3mH9Vh7sq0pS0Uws=;
        b=Qe8/I/SoyfMbx7r6ZlTob46zZbkiyNsb6cVYNKUnlfalU3CGH5L3uJcb1xcC92WoWV
         B/uuw/+dtZU7VdwQk1loyXD2ACDpYRuwEltagst1sOYlwoAH5BvF50FVDuOpWHzctDcR
         zjJFDA7TQj3ogkNllalze+olRfI2nzoTtBdDFhq8Rn0YvQcb0jIYihsRv2WLxRnzvXAq
         EXlA/owk7TTWtEWGyUqXNbhdr0witzIqua7uf/yw5DIoFw+2qznha5A7sFlmEGW3uVnj
         ocSEFDdHSEQC8VQK7dcHIiqRxc0BhMYBrDEW9RMbpJ6JhSutz6AjOwof7326Z4F1VP3W
         TxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hW5H5eUlUgTpOIzdNNZ8H532v4I3mH9Vh7sq0pS0Uws=;
        b=Y7TE/7yyALUP1J+F3TqMdnwQSZYCkPg4ZBcUHL6bcNzcrpToiQOyKkISn+r3M//KjD
         fvaebeIiOEX3SAkiz7CJUo4xUW2KeIOQOets49xxYfR5YkoATjpAkPN70EyfWV3r7CxX
         nTcgWwoHmSnikn5g0B1jWNzVLu5I32Ixa6k8Tu5aecCaNYbiNRC+vt9M6mXx48mwSdqG
         88FnY+I4oQtgiIpb+Y0TpXQmOGwQ3ZqoyNu4IYlpDKotO5unV6UpA1Jznsb2O1FP1fvo
         isqYN8YlhBOlG+nncnie11MFNUzgm02/GJ6T0cqgbH86eg+2F9lCE0UJfMpqtjO/z3p3
         Xj+A==
X-Gm-Message-State: AA+aEWaiQP2pBrlmfHITmDAPtYy83knS0mfYoUcC4Zm+qH7Kre4f2Yv2
        bNNw2IAouaHWMcwLPy2dPe9sog==
X-Google-Smtp-Source: AFSGD/XY/gdT8hzY2aXicgjskg3kiDJH9A/Xz3bFvsWuLsAfGzRVxF1XuJTzX8BjqUNc0yFTpvhDlw==
X-Received: by 2002:a62:53c5:: with SMTP id h188mr15295103pfb.190.1543192622866;
        Sun, 25 Nov 2018 16:37:02 -0800 (PST)
Received: from ?IPv6:2601:646:c200:7429:7069:da99:d9d2:c355? ([2601:646:c200:7429:7069:da99:d9d2:c355])
        by smtp.gmail.com with ESMTPSA id s2sm52205469pfa.167.2018.11.25.16.37.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Nov 2018 16:37:01 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <D45BC005-5064-4C75-B486-4E43C454E2F6@amacapital.net>
Date:   Sun, 25 Nov 2018 16:37:00 -0800
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <94154ECB-3EF7-4A37-9057-0B84DBCE650E@amacapital.net>
References: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181125185524.GA23224@wind.enjellic.com> <D45BC005-5064-4C75-B486-4E43C454E2F6@amacapital.net>
To:     "Dr. Greg" <greg@enjellic.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Bah, I hit send on a partially written draft. I=E2=80=99ll try again soon.

--Andy

> On Nov 25, 2018, at 1:59 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>=20
>=20
>=20
>> On Nov 25, 2018, at 10:55 AM, Dr. Greg <greg@enjellic.com> wrote:
>>=20
>=20
>>=20
>>=20
>> The notion of a launch enclave is critical to establishing these
>> guarantees.  As soon as the kernel becomes involved in implementing
>> SGX security policy the architecture becomes vulnerable to kernel
>> and/or privilege modification attacks.
>>=20
>> We've talked at length about the provisioning bit, I won't go into
>> details unless people are interested, but the EPID provisioning
>> protocol implements an SGX mediated cryptographic contract that a
>> perpetual platform identifier will not be disclosed to anyone but
>> Intel. =20
>=20
> As a reviewer, and as an occasional academic cryptographer, I need to put m=
y foot down here.  This is inaccurate.
>=20
> There is an SGX-mediated contract that says:
>=20
> 1. For any given public key p, a perpetual platform identifier ID_p exists=
 and will only be disclosed to the holder of the corresponding private key p=
_priv or to someone to whom the private key holder permits (intentionally or=
 otherwise) to use that identifier.
>=20
> 2. The ability described in #1 is available to anyone whom the kernel and l=
aunch enclave (if the MSRs are locked ) permits (intentionally or otherwise)=
 to use it.
>=20
> No, I have no clue why Intel did it this way.  I consider it to be a mista=
ke.
>=20
>> The launch enclave is critical to that guarantee.
>>=20
>> It is completely understandable why a locked down, (non-FLC) hardware
>> platform, is undesirable in this community.  That doesn't mean that a
>> launch enclave as a concept is unneeded or necessarily evil.
>>=20
>> In an FLC environment the kernel assumes responsibility for SGX
>> privacy and security.  This means that we need to do at least as well
>> with a kernel based model as to what is currently available.
>>=20
>>> There are other ways to accomplish it that might be better in some
>>> respects.  For example, there could be /dev/sgx and
>>> /dev/sgx_rights/provision.  The former exposes the whole sgx API,
>>> except that it doesn???t allow provisioning by default. The latter
>>> does nothing by itself. To run a provisioning enclave, you open both
>>> nodes, then do something like:
>>>=20
>>> ioctl(sgx, SGX_IOC_ADD_RIGHT, sgx_provisioning);
>>>=20
>>> This requires extra syscalls, but it doesn't have the combinatorial
>>> explosion problem.
>>=20
>> Here is a proposal for the driver to add the needed policy control
>> that is 'SGXy' in nature.  The 'SGXy' way is to use MRSIGNER values as
>> the currency for security policy management.
>>=20
>> The driver should establish the equivalent of three linked lists,
>> maintainable via /sysfs pseudo-files or equivalent plumbing.  The
>> lists are referenced by the kernel to enforce the following policies.
>>=20
>> 1.) The right to initialize an enclave without special attributes.
>>=20
>> 2.) The right to initialize an enclave with the PROVISION_KEY attribute s=
et.
>>=20
>> 3.) The right to initialize an enclave with the LICENSE_KEY attribute set=
.
>>=20
>> The lists are populated with MRSIGNER values of enclaves that are
>> allowed to initialize under the specified conditions.
>=20
> NAK because this is insufficient.  You=E2=80=99re thinking of a model in w=
hich SGX-like protection is all that=E2=80=99s needed.  This is an inadequat=
e model of the real world.  The attack I=E2=80=99m most concerned about wrt p=
rovisioning is an attack in which an unauthorized user is permitted=20
>=20
> The use case I see for attestation *privacy*
>=20
>>=20
>> The driver should either establish a 'seal' file or value,
>> ie. MRSIGNER value of all zero's, that once written will not allow
>> further modifications of the list(s).  This will allow
>> cryptographically guaranteed policies to be setup at early boot that
>> will limit the ability of subsequent DAC compromises to affect policy
>> management.
>>=20
>> The lists are obviously vulnerable to a kernel compromise but the
>> vulnerability scope is significantly limited vs. 'can I get root or
>> some other userid'.  If we are really concerned about the scope of
>> that vulnerability there could be an option on TPM based systems to
>> verify a hash value over the lists once sealed on each enclave
>> initialization.  We have already conceded that EINIT isn't going to be
>> any type of speed daemon.
>>=20
>> On an FLC system the driver verifies that the submitted enclave has an
>> MRSIGNER value on one of the lists consistent with the attributes of
>> the enclave before loading the value into the identity modulus
>> signature registers.
>>=20
>> In this model, I would argue that the driver does not need to
>> arbitrarily exclude launch enclaves as it does now, since the kernel
>> has the ability to specify acceptable launch enclaves.  The driver API
>> can alaso continue to accept an EINITTOKEN which maintains
>> compatibility with the current ABI.  Punishment can be inflicted on
>> non-FLC hardware owners by issueing EINVAL if an EINITTOKEN is
>> specified on platforms with fixed launch keys.
>>=20
>> This also has the effect of allowing multiple launch enclaves at the
>> platform owner's discretion.  I know there was some sentiment, and
>> Jarkko had code, that used a launch enclave at a fixed location such
>> as /lib/firmware.  That has the disadvantage of requiring that the
>> kernel know about all the different ways that a launch enclave might
>> be used or setup.  It also establishes a cryptographic rather then a
>> filesystem based guarantee on the launch enclave being used.
>>=20
>> If the lists are empty the kernel simply proceeds as it does now and
>> loads any enclave submitted to it.
>>=20
>> I believe this architecture has a number of merits.  It largely
>> preserves compatibility with current PSW's and provides a mechanism
>> for cryptographically enforced policy that is consistent with the SGX
>> architecture.
>>=20
>> I need to get Christmas lights put up on the house for the squirrels
>> to eat so I will leave this proposal open for debate.
>>=20
>> Have a good remainder of the weekend or whats left of it.
>>=20
>> Dr. Greg
>>=20
>> As always,
>> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
>> 4206 N. 19th Ave.           Specializing in information infra-structure
>> Fargo, ND  58102            development.
>> PH: 701-281-1686
>> FAX: 701-281-3949           EMAIL: greg@enjellic.com
>> -------------------------------------------------------------------------=
-----
>> "Some of them are.  A surprising number aren't.  A personal favorite of
>> mine was the log from a cracker who couldn't figure out how to untar
>> and install the trojan package he'd ftped onto the machine.  He tried a
>> few times, and then eventually gave up and logged out."
>>                               -- Nat Lanza
