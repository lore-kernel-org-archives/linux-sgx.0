Return-Path: <SRS0=YIp+=U3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1C7C5B57A
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 17:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08459208C4
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 17:22:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="R2m5L1i5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfF1RWM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:22:12 -0400
Received: from sonic314-26.consmr.mail.ne1.yahoo.com ([66.163.189.152]:34737
        "EHLO sonic314-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbfF1RWM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jun 2019 13:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561742529; bh=jktG05AKGtGWXa/Wp+oyzcUCl+haEo+ayin1oRdDjlo=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=R2m5L1i5zXHhFL+c4TMCDUncfffcWYW7qzquSq23O/f4NigF8v9MIRKtehsx38JhJJeWWTOqmzAkewS3ZDPFRi026lx5jQeQ2z7dh273aVT4Qsw6pC0MS2ObO4uC/hYzWWA1gOPdTvi3rSm3dUR4Cvevq4o1380mn9B4uObU7IN+ch1OVPkWcyoMdXXW96ejnuXTASWAAbgD4mZmrm6rpZEk5wfvxC72Jzb5QS7oatr7OdhrXEGjiQX2H4JTPD/1Tay79ANMItQGMio/5Br4aEL61kJNVl5wIZrTuwKFk/R1xLitTAjjLDbTe0MTi2OaG9QgGM2F9LMB5Vz3bOYcOw==
X-YMail-OSG: 0T0C_Q0VM1nTGPblM8udjCjfwa6JsOaasNkivjd8pJy6owT1J8bnLIzhk8Ficw9
 LGTKrW.iyDnu6uL8Z_FMeOxMLWqIb0mp3TCsBCksKWEMHFtTXr0rE1w_LEkgNsw2hTYs_80MMuGc
 8RfgIpHt5M6BeqXsc7LFkw7fl0nm08L26cgUoiG98l23UPSlCWf0sf10d4lyBR7EXIpVUBqtXf8h
 G1R5tx.bVUhP5SqjyRwdUWKlL0gAXOcEbnJpJLlB2TV9NFfV0EThE37.UBagwUY0ddP8FKn.9PB0
 _XB6UaifVtd9hkJxPo7ds3b2ax826d0fgS4RIPPmiX3LVDXJVZJkofc_cHitx8ndN36ohUOdfX.u
 ke0VHSeXyZP.C.jhSil3CtZRX.NxLfQFnYGzzkuVG9mZNd3PzgIl_guYnQQqOrvhbLYGJF8phk1U
 lJCcR06TtBPGal8W69luq_XoFyYAj_dzYXch5UQ9c5DiN6V7o5IARx_ShCT7OEOsDEam9227nqJB
 ayliJZt3ZMeNxhh5ZFcj.hd_EA5MxZVENaQxVHH.GeVz.l2HgWz9_1hUDMz8Z7wZ0rpygwRbAFCe
 1fli93oTKfZ.6haKLfgQjXNQmY3SJwWrP5ztmm5rXW7LlJozj9a_bOzhFkAcmeuRkhnLAfT9MsTg
 YMaaQh.lbgRnReQ9imqqhpKm_nRUS904nykjHbhXKO7iQB7GvR8QZKM4xNophqHb.PLftEuWJJMG
 smuuAHPYso1EVAPfSA01qgvTh01Tys3QvVq1caYkE_JpFzscRjYN03nFT6Ha1w3PoAoptjQ_yS4i
 aubnRckkcXFrAj7AqlIJfmO0ZABtdPU5o5lmvrI4z76hgxssguzR6vsLa1ORL_83LxWOH2NezDw7
 scSwOMPBYbcHqeKxeRUjZ0ulzGK5UKQywEZVg3LD8eNvU0fA3svuKEFjo9xuOxs08OrJEGjSHLcH
 Yx3Lst8WUoYR492ow24330igkETDvAfxJFKy55RCjUtVdXvUmUOU6cYEbQT5BKpeZKojFUtOBXdG
 GQEjXO_9tTAtRfejpaBKbIAGveSBBn_4Hu0vw_l2OSmNURkHKAiry_CFRixqU48q6TsYG4OLVmvi
 SDjZH1qyXNFYNFe3eT4_Reir8X7ZLUZ4jRO1ugpVd0G0Yd1jbdHPgMyQu4KZKlLW8gD9acKvggk7
 aryIj1Ub3tt5_7vWBvRVqqGXvMFFJ_GPPco8OhG22wVXkFfSgvjgZJdecS4Yp7J8UFr6PhUVXwY_
 8HzDufSGQhwILAC5sr2oIhGUvR7cfxXlFiIX6f19jrUjg
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Fri, 28 Jun 2019 17:22:09 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp428.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 7e612a2875cd384ea18fdeca618a6627;
          Fri, 28 Jun 2019 17:22:05 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        casey@schaufler-ca.com
Cc:     "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
 <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com>
Date:   Fri, 28 Jun 2019 10:22:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/27/2019 5:47 PM, Xing, Cedric wrote:
>> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
>> Sent: Thursday, June 27, 2019 4:37 PM
>>>> This code should not be mixed in with the LSM infrastructure.
>>>> It should all be contained in its own module, under security/enclave=
=2E
>>> lsm_ema is *intended* to be part of the LSM infrastructure.
>> That's not going to fly, not for a minute.
> Why not, if there's a need for it?
>
> And what's the concern here if it becomes part of the LSM infrastructur=
e.

The LSM infrastructure provides a framework for hooks
and allocation of blobs. That's it. It's a layer for
connecting system features like VFS, IPC and the IP stack
to the security modules. It does not implement any policy
of it's own. We are not going to implement SGX or any other
mechanism within the LSM infrastructure.

>>>  It is going to be shared among all LSMs that would like to track
>> enclave pages and their origins.
>>
>> That's true for InfiniBand, tun and sctp as well. Look at their
>> implementations.
> As far as I can tell, InfiniBand, tun and sctp, all of them seemed used=
 inside SELinux only.

So?=20

> If you had a chance to look at v1 of my series, I started by burying ev=
erything inside SELinux too. But Stephen pointed out such tracking would =
be needed by all LSMs so code duplication might be a concern. Thus I resp=
onded by moving it into LSM infrastructure.

What you need to do is move all the lsm_ema code into its own
place (which could be security/enclave). Manage your internal
data as you like. LSMs (e.g. SELinux) can call your APIs if
needed. If the LSMs need to store SGX information with the file
structure they need to include that in the space they ask for in
the file blob.


>>> And they could be extended to store more information as deemed
>> appropriate by the LSM module.
>>
>> Which is what blobs are for, but that does not appear to be how
>> you're using either the file blob or your new ema blob.
> A lsm_ema_map pointer is stored in file->f_security.

That's up to the individual security module to decide.

>  Each lsm_ema_map contains a list of lsm_ema structures. In my last pat=
ch, SELinux stores a ema_security_struct with every ema, by setting selin=
ux_blob_sizes.lbs_ema_data to sizeof(ema_security_struct).

You are managing the ema map lists. You don't need the LSM
infrastructure to do that.

> ema_security_struct is initialized in selinux_enclave_load(), and check=
ed in enclave_mprotect(), which is a subroutine of selinux_file_mprotect(=
). BTW, it is alloced/freed automatically by LSM infrastructure in securi=
ty_enclave_load()/security_file_free().

Do you mean security_enclave_load()/security_enclave_free() ?
There is no way you can possibly have sane behavior if you're
allocation and free aren't tied to the same blob.

>>>  The last patch of this series shows how to extend EMA inside SELinux=
=2E
>> I don't see (but I admit the code doesn't make a lot of sense to me)
>> anything you couldn't do in the SELinux code by adding data to the
>> file blob. The data you're adding to the LSM infrastructure doesn't
>> belong there, and it doesn't need to be there.
> You are correct. My v1 did it inside SELinux.
>
> The key question I think is whether only SELinux needs it, or all LSMs =
need it. Stephen thought it was the latter (and I agree with him) so I mo=
ved it into the LSM infrastructure to be shared, just like the auditing c=
ode.

You are both right that it doesn't belong in the SELinux code.
It also doesn't belong as part of the LSM infrastructure.

>>>> Not acceptable for the LSM infrastructure. They
>>>> are inconsistent with the way data is used there.
>>> I'm not sure I understand this comment.
>> It means that your definition and use of the lsm_ema_blob
>> does not match the way other blobs are managed and used.
>> The LSM infrastructure uses these entries in a very particular
>> way, and you're trying to use it differently. Your might be
>> able to change the rest of the enclave system to use it
>> correctly, or you might be able to find a different place
>> for it.
> I'm still not sure why you think this (lbs_ema_data) is inconsistent wi=
th other blobs.=20
>
> Same as all other blobs, an LSM requests it by storing the needed size =
in it, and is assigned an offset, and the buffer is allocated/freed by th=
e infrastructure. Am I missing anything?

Yes. Aside from allocation and deletion the infrastructure does
nothing with the blobs. The blobs are used only by the security
modules. All other data is maintained and used elsewhere. SGX
specific data needs to me maintained and managed elsewhere.

>>> As I stated in the cover letter, the primary question is how to
>> prevent SGX from being abused as a backdoor to make executable pages
>> that would otherwise not be executable without SGX. Any LSM module
>> unaware of that would leave that "hole" open. So tracking enclave page=
s
>> will become a common task for all LSMs that care page protections, and=

>> that's why I place it inside LSM infrastructure.
>>
>> Page protections are an important part of many security features,
>> but that's beside the point. The LSM system provides mechanism for
>> providing additional restrictions to existing security mechanisms.
>> First, you create the security mechanism (e.g. enclaves) then you
>> add LSM hooks so that security modules (e.g. SELinux) can apply
>> their own policies in addition. In support of this, the LSM blob
>> mechanism allows security modules to maintain their own information
>> about the system components (e.g. file, inode, cred, task) they
>> care about. The LSM infrastructure does not itself provide or
>> support security data or policy. That's strictly for the modules
>> to do.
> Agreed!
>
> EMA doesn't dictate policies for sure. Is it considered "security data"=
? I'm not sure the definition of "security data" here. It does store some=
 "data", something that multiple LSM modules would need to duplicate if n=
ot pulled into a common place. It is meant to be a "helper" data structur=
e, just like the auditing code.

Good example. You'll see that there is no audit code in the
LSM infrastructure. None. No audit data, either. It's all taken
care of in the audit system.


