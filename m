Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBD0C5B577
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 23:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531F520B7C
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 23:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="TkOdo6Ew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfF0XhQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 19:37:16 -0400
Received: from sonic314-27.consmr.mail.ne1.yahoo.com ([66.163.189.153]:35702
        "EHLO sonic314-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfF0XhP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Jun 2019 19:37:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561678632; bh=tOXISVHV7MuX+asqA9Xg4l5RxNWHU700RJd7QixfB30=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=TkOdo6Ewq+4/TboNubC8ECrAu68agthAPecd/hf97OBV0v/8saPFKDGx8GcqFo8XvHOSGiITnk414rug+jGVP0mDicvpimrn6PMD4EkQagAYdwGSOEMMLkB2MsGOZkyyX4zgsqVLJz/MY/GA8TWY7KdqcHFmtJ0DzdZR8NNEEw+wWR0KITh4/AQ/HWJ2YPMrnLTEc7Rx6Rt1yMzWDAuovmWtjJrznC8X7RhFwIyXayUg+FEmj8qZtHCqHouXVP7NfzhQ0z7UNAQGK40xMvEhP8cfXoo/fBRlbo6xzuF+XL8lLy+QxXMA7bf+5WmWBdP+ox+vWQHjR/6311rssRzSfg==
X-YMail-OSG: DwwUXfoVM1ldkY6HSfoWwxxbXMTu3EWNCXOaFsCAVg.YytdojKNGufzeoMYoZpG
 WFPw7duH0cIPb0ZqJQtFvue.ez_hn7X1siDtSEjR20IoL_FcYVDRZt.PS7yVfegC6AJLrl8Hcc64
 YANpjvVkh0.Rk5ZrEhUiLhV54HEUTG1uS5UXw8XO6_HNuiO8CpmF2N8oxSiIPSMI_vhUAiNMpyS4
 SmxskBPFpfCmKMODe_yEpi04tT4WidqXL6kw9zS4AsSkELHmxHEdWG9z8OSUX73AaWEKUVhmDrxH
 bvBa.gYLIxKeCiAvLImixWE5kRN7pd3UhKGcFcjxEREapXo6_WhC42PiRQzDVFJoLXSrgNefVPk9
 Rsip32ne8bEJpxKFMCcv758dba_wMfes.sKs6App8Ma0Se1fGwqlStH7RqP93p_vfPwJkisjlR9E
 Dc_vzXzXzV4_9vSnuqfbbNSY6Ze5x2ejtSRb3nmNKHLXPSWgCYJUwzbl0nrZPG.cTbU9aT2XctLE
 i.ExW4EO.V.fV63WDuNfkyzSPLIg041FG.TcicgI3CgW50KI2TZUNSKlyximLrX3uV9UH7HZYthX
 oeMzMww2kmciYtsm2mV.ZasN9s62OIiICESHde_sCnSi5xTF5_cg5B4iJiV3f2S.QwejevjG1Slr
 4_32J1A.aPw4twipCuLbgLbPZOqUf0ud4qgJT6_CfLYbyx6wm5vGVfLp0.LAnZ9h7Rkcx.rEYNrP
 IhKnROJMfKvsyZZ5hO0TfyHaBp8vBrkWwTMoqlFkaYvWzVycerc3UMspKuysX17QGq1_5u4g9rtx
 kKJAGlykUq87Zj9Tk3th31sBCpOfiynf2Na.MI_P8HGgxXnfqrrWWSVMoSMkl6m3MYYKIkDXgRtR
 FU4.zZyv_6wtXMm3Il_qNeKoOFKAKOzXuKsAMf0L6m.4aEXFenJ5vaIAm19L1r0CtCyXCgvcNgUn
 erFmiaK1DGCMfaVmKmHmSHJsFzyvFaT0YqjE2asJMFHdwB14avWNKXPJNVf9XeB11WDlVHvbmMw1
 TMIp8P9VOTooenQPZL1_KDmsAUFoHKeXbU9yD2ZfNM5ApS0O6am1Wj2fT.QDGzdUsfLVoWc7vsYi
 .kE69gE4UWEIuZ_5gL4D1mKd6cxd.kkEYM6PjUmy_ezTONCwQ7.pgqlqz_bp0mNfH3.7FIqsS.Cy
 yv37787DfQQnb_1J_Y.aEqKzywzdHZUDIV5vp1jk_6oLqy3xLdNTt7ipTgE_g8b5Ct_KquLhJ__s
 qSoJ2RZqNi4kAaX7UZQ.SrlwHF.u6Np78NP9Vs.SfJ5bNyg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Thu, 27 Jun 2019 23:37:12 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp432.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 5f1490413d738bd08b2d26c4f61eabc9;
          Thu, 27 Jun 2019 23:37:11 +0000 (UTC)
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
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 mQINBFzV9HABEAC/mmv3jeJyF7lR7QhILYg1+PeBLIMZv7KCzBSc/4ZZipoWdmr77Lel/RxQ
 1PrNx0UaM5r6Hj9lJmJ9eg4s/TUBSP67mTx+tsZ1RhG78/WFf9aBe8MSXxY5cu7IUwo0J/CG
 vdSqACKyYPV5eoTJmnMxalu8/oVUHyPnKF3eMGgE0mKOFBUMsb2pLS/enE4QyxhcZ26jeeS6
 3BaqDl1aTXGowM5BHyn7s9LEU38x/y2ffdqBjd3au2YOlvZ+XUkzoclSVfSR29bomZVVyhMB
 h1jTmX4Ac9QjpwsxihT8KNGvOM5CeCjQyWcW/g8LfWTzOVF9lzbx6IfEZDDoDem4+ZiPsAXC
 SWKBKil3npdbgb8MARPes2DpuhVm8yfkJEQQmuLYv8GPiJbwHQVLZGQAPBZSAc7IidD2zbf9
 XAw1/SJGe1poxOMfuSBsfKxv9ba2i8hUR+PH7gWwkMQaQ97B1yXYxVEkpG8Y4MfE5Vd3bjJU
 kvQ/tOBUCw5zwyIRC9+7zr1zYi/3hk+OG8OryZ5kpILBNCo+aePeAJ44znrySarUqS69tuXd
 a3lMPHUJJpUpIwSKQ5UuYYkWlWwENEWSefpakFAIwY4YIBkzoJ/t+XJHE1HTaJnRk6SWpeDf
 CreF3+LouP4njyeLEjVIMzaEpwROsw++BX5i5vTXJB+4UApTAQARAQABtChDYXNleSBTY2hh
 dWZsZXIgPGNhc2V5QHNjaGF1Zmxlci1jYS5jb20+iQJUBBMBCAA+FiEEC+9tH1YyUwIQzUIe
 OKUVfIxDyBEFAlzV9HACGwMFCRLMAwAFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQOKUV
 fIxDyBG6ag/6AiRl8yof47YOEVHlrmewbpnlBTaYNfJ5cZflNRKRX6t4bp1B2YV1whlDTpiL
 vNOwFkh+ZE0eI5M4x8Gw2Oiok+4Q5liA9PHTozQYF+Ia+qdL5EehfbLGoEBqklpGvG3h8JsO
 7SvONJuFDgvab/U/UriDYycJwzwKZuhVtK9EMpnTtUDyP3DY+Q8h7MWsniNBLVXnh4yBIEJg
 SSgDn3COpZoFTPGKE+rIzioo/GJe8CTa2g+ZggJiY/myWTS3quG0FMvwvNYvZ4I2g6uxSl7n
 bZVqAZgqwoTAv1HSXIAn9muwZUJL03qo25PFi2gQmX15BgJKQcV5RL0GHFHRThDS3IyadOgK
 P2j78P8SddTN73EmsG5OoyzwZAxXfck9A512BfVESqapHurRu2qvMoUkQaW/2yCeRQwGTsFj
 /rr0lnOBkyC6wCmPSKXe3dT2mnD5KnCkjn7KxLqexKt4itGjJz4/ynD/qh+gL7IPbifrQtVH
 JI7cr0fI6Tl8V6efurk5RjtELsAlSR6fKV7hClfeDEgLpigHXGyVOsynXLr59uE+g/+InVic
 jKueTq7LzFd0BiduXGO5HbGyRKw4MG5DNQvC//85EWmFUnDlD3WHz7Hicg95D+2IjD2ZVXJy
 x3LTfKWdC8bU8am1fi+d6tVEFAe/KbUfe+stXkgmfB7pxqW5Ag0EXNX0cAEQAPIEYtPebJzT
 wHpKLu1/j4jQcke06Kmu5RNuj1pEje7kX5IKzQSs+CPH0NbSNGvrA4dNGcuDUTNHgb5Be9hF
 zVqRCEvF2j7BFbrGe9jqMBWHuWheQM8RRoa2UMwQ704mRvKr4sNPh01nKT52ASbWpBPYG3/t
 WbYaqfgtRmCxBnqdOx5mBJIBh9Q38i63DjQgdNcsTx2qS7HFuFyNef5LCf3jogcbmZGxG/b7
 yF4OwmGsVc8ufvlKo5A9Wm+tnRjLr/9Mn9vl5Xa/tQDoPxz26+aWz7j1in7UFzAarcvqzsdM
 Em6S7uT+qy5jcqyuipuenDKYF/yNOVSNnsiFyQTFqCPCpFihOnuaWqfmdeUOQHCSo8fD4aRF
 emsuxqcsq0Jp2ODq73DOTsdFxX2ESXYoFt3Oy7QmIxeEgiHBzdKU2bruIB5OVaZ4zWF+jusM
 Uh+jh+44w9DZkDNjxRAA5CxPlmBIn1OOYt1tsphrHg1cH1fDLK/pDjsJZkiH8EIjhckOtGSb
 aoUUMMJ85nVhN1EbU/A3DkWCVFEA//Vu1+BckbSbJKE7Hl6WdW19BXOZ7v3jo1q6lWwcFYth
 esJfk3ZPPJXuBokrFH8kqnEQ9W2QgrjDX3et2WwZFLOoOCItWxT0/1QO4ikcef/E7HXQf/ij
 Dxf9HG2o5hOlMIAkJq/uLNMvABEBAAGJAjwEGAEIACYWIQQL720fVjJTAhDNQh44pRV8jEPI
 EQUCXNX0cAIbDAUJEswDAAAKCRA4pRV8jEPIEWkzEACKFUnpp+wIVHpckMfBqN8BE5dUbWJc
 GyQ7wXWajLtlPdw1nNw0Wrv+ob2RCT7qQlUo6GRLcvj9Fn5tR4hBvR6D3m8aR0AGHbcC62cq
 I7LjaSDP5j/em4oVL2SMgNTrXgE2w33JMGjAx9oBzkxmKUqprhJomPwmfDHMJ0t7y39Da724
 oLPTkQDpJL1kuraM9TC5NyLe1+MyIxqM/8NujoJbWeQUgGjn9uxQAil7o/xSCjrWCP3kZDID
 vd5ZaHpdl8e1mTExQoKr4EWgaMjmD/a3hZ/j3KfTVNpM2cLfD/QwTMaC2fkK8ExMsz+rUl1H
 icmcmpptCwOSgwSpPY1Zfio6HvEJp7gmDwMgozMfwQuT9oxyFTxn1X3rn1IoYQF3P8gsziY5
 qtTxy2RrgqQFm/hr8gM78RhP54UPltIE96VywviFzDZehMvuwzW//fxysIoK97Y/KBZZOQs+
 /T+Bw80Pwk/dqQ8UmIt2ffHEgwCTbkSm711BejapWCfklxkMZDp16mkxSt2qZovboVjXnfuq
 wQ1QL4o4t1hviM7LyoflsCLnQFJh6RSBhBpKQinMJl/z0A6NYDkQi6vEGMDBWX/M2vk9Jvwa
 v0cEBfY3Z5oFgkh7BUORsu1V+Hn0fR/Lqq/Pyq+nTR26WzGDkolLsDr3IH0TiAVH5ZuPxyz6
 abzjfg==
Message-ID: <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
Date:   Thu, 27 Jun 2019 16:37:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/27/2019 3:52 PM, Xing, Cedric wrote:
> Hi Casey,
>
>> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
>> Sent: Thursday, June 27, 2019 3:07 PM
>>
>> Don't use "lsm_ema". This isn't LSM infrastructure.
>> Three letter abbreviations are easy to type, but are doomed to encount=
er
>> conflicts and lead to confusion.
>> I suggest that you use "enclave", because it doesn't start off
>> conflicting with anything and is descriptive.
>>
>> This code should not be mixed in with the LSM infrastructure.
>> It should all be contained in its own module, under security/enclave.
> lsm_ema is *intended* to be part of the LSM infrastructure.

That's not going to fly, not for a minute.

>  It is going to be shared among all LSMs that would like to track encla=
ve pages and their origins.

That's true for InfiniBand, tun and sctp as well. Look at their implement=
ations.

> And they could be extended to store more information as deemed appropri=
ate by the LSM module.

Which is what blobs are for, but that does not appear to be how
you're using either the file blob or your new ema blob.

>  The last patch of this series shows how to extend EMA inside SELinux.

I don't see (but I admit the code doesn't make a lot of sense to me)
anything you couldn't do in the SELinux code by adding data to the
file blob. The data you're adding to the LSM infrastructure doesn't
belong there, and it doesn't need to be there.

>
>>> diff --git a/include/linux/lsm_ema.h b/include/linux/lsm_ema.h new
>>> file mode 100644 index 000000000000..a09b8f96da05
>>> --- /dev/null
>>> +++ b/include/linux/lsm_ema.h
>> There's no need for this header to be used outside the enclave
>> LSM. It should be "security/enclave/enclave.h"
> This header file is supposed to be used by all LSM modules, similar to =
lsm_hooks.h. Hence it is placed in the same location.
>
>>
>>> @@ -0,0 +1,171 @@
>>> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
>>> +/**
>>> + * Enclave Memory Area interface for LSM modules
>>> + *
>>> + * Copyright(c) 2016-19 Intel Corporation.
>>> + */
>>> +
>>> +#ifndef _LSM_EMA_H_
>>> +#define _LSM_EMA_H_
>>> +
>>> +#include <linux/list.h>
>>> +#include <linux/mutex.h>
>>> +#include <linux/fs.h>
>>> +#include <linux/file.h>
>>> +
>>> +/**
>>> + * lsm_ema - LSM Enclave Memory Area structure
>> How about s/lsm_ema/enclave/ ?
> I understand your suggestion, but this structure is shared among all LS=
Ms. And I think lsm_ema is pretty descriptive without being too verbose.
>
>>> + *
>>> + * Data structure to track origins of enclave pages
>>> + *
>>> + * @link:
>>> + *	Link to adjacent EMAs. EMAs are sorted by their addresses in
>> ascending
>>> + *	order
>>> + * @start:
>>> + *	Starting address
>>> + * @end:
>>> + *	Ending address
>>> + * @source:
>>> + *	File from which this range was loaded from, or NULL if not loaded=

>> from
>>> + *	any files
>>> + */
>>> +struct lsm_ema {
>>> +	struct list_head	link;
>>> +	size_t			start;
>>> +	size_t			end;
>>> +	struct file		*source;
>>> +};
>>> +
>>> +#define lsm_ema_data(ema, blob_sizes)	\
>>> +	((char *)((struct lsm_ema *)(ema) + 1) + blob_sizes.lbs_ema_data)
>> Who uses this? The enclave LSM? Convention would have this
>> be selinux_enclave(ema) for the SELinux code. This is
>> inconsistent with the way other blobs are handled.
> This is to be used in various LSMs. As you can see in the last patch of=
 this series, selinux_ema() is defined as a wrapper of this macro.
>
>>> +
>>> +/**
>>> + * lsm_ema_map - LSM Enclave Memory Map structure
>> enclave_map
>>
>>> + *
>>> + * Container for EMAs of an enclave
>>> + *
>>> + * @list:
>>> + *	Head of a list of sorted EMAs
>>> + * @lock:
>>> + *	Acquire before querying/updateing the list EMAs
>>> + */
>>> +struct lsm_ema_map {
>>> +	struct list_head	list;
>>> +	struct mutex		lock;
>>> +};
>>> +
>>> +/**
>>> + * These are functions to be used by the LSM framework, and must be
>> defined
>>> + * regardless CONFIG_INTEL_SGX is enabled or not.
>> Not acceptable for the LSM infrastructure. They
>> are inconsistent with the way data is used there.
> I'm not sure I understand this comment.

It means that your definition and use of the lsm_ema_blob
does not match the way other blobs are managed and used.
The LSM infrastructure uses these entries in a very particular
way, and you're trying to use it differently. Your might be
able to change the rest of the enclave system to use it
correctly, or you might be able to find a different place
for it.


>>> + */
>>> +
>>> +#ifdef CONFIG_INTEL_SGX
>>> +void lsm_ema_global_init(size_t);
>>> +void lsm_free_ema_map(atomic_long_t *);
>>> +#else
>>> +static inline void lsm_ema_global_init(size_t ema_data_size)
>>> +{
>>> +}
>>> +
>>> +static inline void lsm_free_ema_map(atomic_long_t *p)
>>> +{
>>> +}
>>> +#endif
>>> +
>>> +/**
>>> + * Below are APIs to be used by LSM modules
>>> + */
>>> +
>>> +struct lsm_ema_map *lsm_init_or_get_ema_map(atomic_long_t *);
>>> +struct lsm_ema *lsm_alloc_ema(void);
>> Do you mean security_alloc_enclave()?
>> That would go into security/security.h
> No. Neither lsm_alloc_ema() above, nor lsm_free_ema() below, is LSM hoo=
k. They are APIs to deal with EMAs.
>
>>> +void lsm_free_ema(struct lsm_ema *);
>> Do you mean security_free_enclave()?
>> That would go into security/security.h
>>
>>> +void lsm_init_ema(struct lsm_ema *, size_t, size_t, struct file *);
>> This goes in the enclave LSM.
> There's NO enclave LSM. This patch is introducing new LSM hooks applica=
ble to all LSM modules, but not introducing new LSM modules.
>
>>> +int lsm_merge_ema(struct lsm_ema *, struct lsm_ema_map *);
>>> +struct lsm_ema *lsm_split_ema(struct lsm_ema *, size_t, struct
>> lsm_ema_map *);
>>> +
>>> +static inline struct lsm_ema_map *lsm_get_ema_map(struct file *f)
>>> +{
>>> +	return (void *)atomic_long_read(f->f_security);
>>> +}
>>> +
>>> +static inline int __must_check lsm_lock_ema(struct lsm_ema_map *map)=

>>> +{
>>> +	return mutex_lock_interruptible(&map->lock);
>>> +}
>>> +
>>> +static inline void lsm_unlock_ema(struct lsm_ema_map *map)
>>> +{
>>> +	mutex_unlock(&map->lock);
>>> +}
>>> +
>>> +static inline struct lsm_ema *lsm_prev_ema(struct lsm_ema *p,
>>> +					   struct lsm_ema_map *map)
>>> +{
>>> +	p =3D list_prev_entry(p, link);
>>> +	return &p->link =3D=3D &map->list ? NULL : p;
>>> +}
>>> +
>>> +static inline struct lsm_ema *lsm_next_ema(struct lsm_ema *p,
>>> +					   struct lsm_ema_map *map)
>>> +{
>>> +	p =3D list_next_entry(p, link);
>>> +	return &p->link =3D=3D &map->list ? NULL : p;
>>> +}
>>> +
>>> +static inline struct lsm_ema *lsm_find_ema(struct lsm_ema_map *map,
>> size_t a)
>>> +{
>>> +	struct lsm_ema *p;
>>> +
>>> +	BUG_ON(!mutex_is_locked(&map->lock));
>>> +
>>> +	list_for_each_entry(p, &map->list, link)
>>> +		if (a < p->end)
>>> +			break;
>>> +	return &p->link =3D=3D &map->list ? NULL : p;
>>> +}
>>> +
>>> +static inline int lsm_insert_ema(struct lsm_ema_map *map, struct
>> lsm_ema *n)
>>> +{
>>> +	struct lsm_ema *p =3D lsm_find_ema(map, n->start);
>>> +
>>> +	if (!p)
>>> +		list_add_tail(&n->link, &map->list);
>>> +	else if (n->end <=3D p->start)
>>> +		list_add_tail(&n->link, &p->link);
>>> +	else
>>> +		return -EEXIST;
>>> +
>>> +	lsm_merge_ema(n, map);
>>> +	if (p)
>>> +		lsm_merge_ema(p, map);
>>> +	return 0;
>>> +}
>>> +
>>> +static inline int lsm_for_each_ema(struct lsm_ema_map *map, size_t
>> start,
>>> +				   size_t end, int (*cb)(struct lsm_ema *,
>>> +							 void *), void *arg)
>>> +{
>>> +	struct lsm_ema *ema;
>>> +	int rc;
>>> +
>>> +	ema =3D lsm_find_ema(map, start);
>>> +	while (ema && end > ema->start) {
>>> +		if (start > ema->start)
>>> +			lsm_split_ema(ema, start, map);
>>> +		if (end < ema->end)
>>> +			ema =3D lsm_split_ema(ema, end, map);
>>> +
>>> +		rc =3D (*cb)(ema, arg);
>>> +		lsm_merge_ema(ema, map);
>>> +		if (rc)
>>> +			return rc;
>>> +
>>> +		ema =3D lsm_next_ema(ema, map);
>>> +	}
>>> +
>>> +	if (ema)
>>> +		lsm_merge_ema(ema, map);
>>> +	return 0;
>>> +}
>> There is no way that these belong as part of the LSM
>> infrastructure. If you need an enclave management API
>> you need to find some other place for it.
> They are NO enclave management APIs. They don't manage enclaves. They t=
rack origins of enclave pages. They are needed by all LSMs.
>
> As I stated in the cover letter, the primary question is how to prevent=
 SGX from being abused as a backdoor to make executable pages that would =
otherwise not be executable without SGX. Any LSM module unaware of that w=
ould leave that "hole" open. So tracking enclave pages will become a comm=
on task for all LSMs that care page protections, and that's why I place i=
t inside LSM infrastructure.

Page protections are an important part of many security features,
but that's beside the point. The LSM system provides mechanism for
providing additional restrictions to existing security mechanisms.
First, you create the security mechanism (e.g. enclaves) then you
add LSM hooks so that security modules (e.g. SELinux) can apply
their own policies in addition. In support of this, the LSM blob
mechanism allows security modules to maintain their own information
about the system components (e.g. file, inode, cred, task) they
care about. The LSM infrastructure does not itself provide or
support security data or policy. That's strictly for the modules
to do.



